//
// Created by lowe on 2019-01-06.
//

import Foundation

public final class SingleList<T> {
    deinit {
        var current = _head
        while let c = current {
            current = c.pointee.next
            delete(node: c)
        }
    }

    public init() {
        self.count = 0
        self._head = nil
    }

    public init(values: [T]) {
        guard !values.isEmpty else {
            return
        }

        let first = values.first!
        let head = PNode.allocate(capacity: 1)
        head.initialize(to: Node(value: first))

        var current = head
        for value in values.dropFirst() {
            let p = makeNode(value)
            current.pointee.next = p
            current = p
        }

        self._head = head
        self.count = values.count
    }

    public var head: PNode {
        assert(!isEmpty)
        return _head!
    }

    public var count: Int = 0

    public var isEmpty: Bool {
        return count == 0
    }

    public subscript(index: Int) -> PNode {
        assert(index < count && index >= 0)
        var current = _head
        for _ in 0 ..< index {
            current = current?.pointee.next
        }
        return current!
    }

    @discardableResult
    public func insert(_ value: T, at: PNode? = nil) -> PNode {
        if isEmpty {
            _head = makeNode(value)
            count += 1
            return _head!
        }

        if let node = at {
            return insert(value, at: node)
        }

        var current = _head
        while let c = current?.pointee.next {
            current = c
        }

        let newNode = makeNode(value)
        current?.pointee.next = newNode
        count += 1
        return newNode
    }

    public func remove(at: PNode) {
        // 只有一个节点
        if count == 1 {
            assert(at == _head)
            delete(node: at)
            _head = nil
            return
        }

        // 删除中间节点
        if let next = at.pointee.next {
            at.pointee.value = next.pointee.value
            at.pointee.next = next.pointee.next
            delete(node: next)
            return
        }

        // 删除尾节点
        var current = _head
        var pre: PNode?
        while let next = current?.pointee.next {
            if next == at {
                pre = current
                break
            }
            current = next
        }

        if let pre = pre {
            delete(node: at)
            pre.pointee.next = nil
        }
    }

    public func reverse() {
        guard let head = self._head else {
            return
        }

        var next = head.pointee.next
        var current: PNode = head
        current.pointee.next = nil

        while let n = next {
            let temp = n.pointee.next
            n.pointee.next = current
            current = n
            next = temp
        }

        self._head = current
    }

    private func makeNode(_ value: T) -> PNode {
        let newNode = PNode.allocate(capacity: 1)
        newNode.initialize(to: Node(value: value))
        return newNode
    }

    private func delete(node: PNode) {
        node.pointee.next = nil
        node.deinitialize(count: 1)
        node.deallocate()
        count -= 1
    }

    @discardableResult
    private func insert(_ value: T, at: PNode) -> PNode {
        let newNode = makeNode(at.pointee.value)
        newNode.pointee.next = at.pointee.next
        at.pointee.value = value
        at.pointee.next = newNode
        count += 1
        return at
    }

    private var _head: PNode?
}

public extension SingleList {
    typealias PNode = UnsafeMutablePointer<Node>

    struct Node {
        var value: T
        var next: PNode?

        init(value: T, next: PNode? = nil) {
            self.value = value
            self.next = next
        }
    }
}

extension SingleList: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: T...) {
        self.init(values: elements)
    }
}

extension SingleList: Sequence {
    public func makeIterator() -> AnyIterator<PNode> {
        var current = _head
        return AnyIterator {
            let next = current
            current = next?.pointee.next
            return next
        }
    }
}

extension SingleList where T: Comparable {
    public func index(of value: T) -> PNode? {
        guard let head = self._head else {
            return nil
        }
        if head.pointee.value == value {
            return head
        }

        var current = head.pointee.next
        while let c = current {
            if c.pointee.value == value {
                current = c
                break
            }

            current = c.pointee.next
        }

        return current
    }
}

extension SingleList: CustomStringConvertible where T: CustomStringConvertible {
    public var description: String {
        guard let head = self._head else {
            return ""
        }

        var str = "\(head.pointee.value)->"
        var current = head
        while let n = current.pointee.next {
            str.append("\(n.pointee.value)->")
            current = n
        }
        return String(str.dropLast(2))
    }
}

extension SingleList: Equatable where T: Equatable {
    public static func ==(lhs: SingleList<T>, rhs: SingleList<T>) -> Bool {
        guard lhs.count == rhs.count else {
            return false
        }

        for (l, r) in zip(lhs, rhs) {
            if l.pointee.value != r.pointee.value {
                return false
            }
        }

        return true
    }
}