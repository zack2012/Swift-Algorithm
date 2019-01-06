//
// Created by lowe on 2019-01-06.
//

import Foundation

import XCTest
@testable import SwiftAlgorithm

final class SingleListTests: XCTestCase {
    static var allTests = [
        ("testCreate", testCreate),
        ("testInsert", testInsert),
        ("testRemove", testRemove),
    ]

    func testCreate() {
        let values = [1, 2, 3, 4, 5, 6]
        let list = SingleList(values: values)

        XCTAssertEqual(list.count, values.count)

        for (pnode, i) in zip(list, values) {
            XCTAssert(pnode.pointee.value == i)
        }

        let emptyList = SingleList<Int>()
        XCTAssert(emptyList.isEmpty)

        let list1: SingleList = [5,4,3]
        XCTAssertEqual(list1.count, 3)
    }

    func testInsert() {
        let list = SingleList<Int>()
        list.insert(0)
        XCTAssert(list.count == 1)
        XCTAssert(list[0].pointee.value == 0)

        list.insert(1, at: list.head)
        XCTAssert(list.count == 2)
        XCTAssert(list.head.pointee.value == 1)

        list.insert(10)
        XCTAssert(list.count == 3)
        XCTAssert(list[2].pointee.value == 10)
    }

    func testRemove() {
        let list: SingleList = [5,4,3,20]

        list.remove(at: list.head)
        XCTAssertEqual(list.head.pointee.value, 4)
        XCTAssert(list.count == 3)

        list.remove(at: list[1])
        XCTAssertEqual(list.head.pointee.value, 4)
        XCTAssertEqual(list[1].pointee.value, 20)
        XCTAssert(list.count == 2)


        list.remove(at: list[1])
        XCTAssertEqual(list[0].pointee.value, 4)
        XCTAssert(list.count == 1)

        list.remove(at: list[0])
        XCTAssert(list.isEmpty)
    }

    func testFind() {
        let list: SingleList = [5,4,3,20]
        XCTAssertEqual(list.index(of: 5), list.head)
        XCTAssertEqual(list.index(of: 20), list[3])
        XCTAssertEqual(list.index(of: 3), list[2])
    }
}