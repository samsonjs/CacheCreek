//
//  CacheCreekTests.swift
//  CacheCreekTests
//
//  Created by Christopher Luu on 1/26/16.
//
//

import XCTest
@testable import CacheCreek

class CacheCreekTests: XCTestCase {

    typealias Node = DoublyLinkedListNode

    func testSettingAndGettingItems() {
        let cache = LRUCache()
        cache.set(item: 123, forKey: "123")

        XCTAssert(cache.count == 1)
        XCTAssert(cache.item(forKey: "123") == 123)
        XCTAssert(cache[123] == nil)

        cache[234] = "234"

        XCTAssert(cache.count == 2)
        XCTAssert(cache.item(forKey: 234) == "234")

        // Test setting/getting an array
        let array = [1, 2, 3, 4, 5]
        cache[5] = array

        XCTAssert(cache.count == 3)
        if let fetchedArray: [Int] = cache.item(forKey: 5) {
            XCTAssert(fetchedArray == array)
        }
        else {
            XCTFail("Expected an int array")
        }

        let testStruct = TestStruct(name: "Testing", value: Int(arc4random_uniform(100000)))
        cache["TestingStruct"] = testStruct

        guard let fetchedStruct: TestStruct = cache.item(forKey: "TestingStruct") else {
            XCTFail()
            return
        }
        XCTAssert(testStruct.name == fetchedStruct.name)
        XCTAssert(testStruct.value == fetchedStruct.value)
    }

    func testDifferentKindsOfKeys() {
        let cache = LRUCache()

        let floatKey: Float = 123.456
        cache.set(item: 123.456, forKey: floatKey)
        XCTAssert(cache.item(forKey: floatKey) as Double? == .some(123.456))

        cache[floatKey] = 456.789
        XCTAssert(cache.count == 1)
        XCTAssert(cache[floatKey] as? Double == .some(456.789))

        cache.set(item: "123.456", forKey: "123.456")
        XCTAssert(cache.count == 2)
        XCTAssert(cache.item(forKey: "123.456") as String? == .some("123.456"))

        let boolKey = true
        cache.set(item: true, forKey: boolKey)
        XCTAssert(cache.count == 3)
        XCTAssert(cache.item(forKey: boolKey) as Bool? == .some(true))

        cache.removeItem(forKey: boolKey)
        XCTAssert(cache.count == 2)
        XCTAssert(cache.item(forKey: boolKey) as Bool? == .none)
    }

    func testSettingAndGettingEnum() {
        let cache = LRUCache()
        cache["ABC"] = TestEnum.abc
        cache["DEF"] = TestEnum.def("BlahBlahBlah")
        cache["GHI"] = TestEnum.ghi(-500)

        guard let abc: TestEnum = cache.item(forKey: "ABC"),
            let def: TestEnum = cache.item(forKey: "DEF"),
            let ghi: TestEnum = cache.item(forKey: "GHI")
            else {
                XCTFail()
                return
            }
        switch (abc, def, ghi) {
        case (.abc, .def(let stringValue), .ghi(let intValue)):
            XCTAssert(stringValue == "BlahBlahBlah")
            XCTAssert(intValue == -500)
        default:
            XCTFail()
        }
    }

    func testSubscripts() {
        let cache = LRUCache()

        // Int subscript
        cache[123] = 123
        XCTAssert(cache[123] as? Int == .some(123))
        XCTAssert(cache.count == 1)

        cache[123] = nil
        XCTAssert(cache[123] as? Int == .none)
        XCTAssert(cache.count == 0)

        // String subscript
        cache["123"] = 123
        XCTAssert(cache["123"] as? Int == .some(123))
        XCTAssert(cache.count == 1)

        cache["123"] = nil
        XCTAssert(cache["123"] as? Int == .none)
        XCTAssert(cache.count == 0)

        // Float subscript
        let floatKey: Float = 3.14
        cache[floatKey] = 123
        XCTAssert(cache[floatKey] as? Int == .some(123))
        XCTAssert(cache.count == 1)
        
        cache[floatKey] = nil
        XCTAssert(cache[floatKey] as? Int == .none)
        XCTAssert(cache.count == 0)
    }

    func testRemovingItems() {
        let cache = LRUCache()
        cache.set(item: 123, forKey: 123)
        cache.set(item: 234, forKey: 234)
        cache.set(item: 345, forKey: 345)
        cache.set(item: 456, forKey: 456)

        XCTAssert(cache.count == 4)

        cache.removeItem(forKey: 123)

        XCTAssert(cache.count == 3)
        XCTAssert(cache[123] == nil)

        cache[234] = nil

        XCTAssert(cache.count == 2)
        XCTAssert(cache[234] == nil)

        cache.removeAllItems()

        XCTAssert(cache.count == 0)

        cache.set(item: 123, forKey: 123)
        cache.set(item: 234, forKey: 234)
        cache.set(item: 345, forKey: 345)
        cache.set(item: 456, forKey: 456)

        XCTAssert(cache.count == 4)

        NotificationCenter.default.post(name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: UIApplication.shared)

        XCTAssert(cache.count == 0)

        cache.set(item: 123, forKey: 123)
        cache.set(item: 234, forKey: 234)
        cache.set(item: 345, forKey: 345)
        cache.set(item: 456, forKey: 456)

        XCTAssert(cache.count == 4)

        NotificationCenter.default.post(name: NSNotification.Name.UIApplicationDidEnterBackground, object: UIApplication.shared)

        XCTAssert(cache.count == 0)

        cache.set(item: 123, forKey: 123)
        cache.set(item: 234, forKey: 234)
        cache.set(item: 345, forKey: 345)
        cache.set(item: 456, forKey: 456)

        XCTAssert(cache.count == 4)

        // Make sure an unknown key doesn't have any weird side effects
        cache[567] = nil

        XCTAssert(cache.count == 4)

        cache.removeItem(forKey: 999)

        XCTAssert(cache.count == 4)
    }

    func testCountLimit() {
        let cache = LRUCache()
        cache.set(item: 123, forKey: 123)
        cache.set(item: 234, forKey: 234)
        cache.set(item: 345, forKey: 345)
        cache.set(item: 456, forKey: 456)

        XCTAssert(cache.count == 4)

        cache.countLimit = 3

        XCTAssert(cache.count == 3)

        cache.removeAllItems()

        XCTAssert(cache.count == 0)

        cache.set(item: 123, forKey: 123)
        cache.set(item: 234, forKey: 234)
        cache.set(item: 345, forKey: 345)
        cache.set(item: 456, forKey: 456)

        XCTAssert(cache.count == 3)

        cache[567] = 567
        XCTAssert(cache.count == 3)

        cache.removeAllItems()

        cache.set(item: 123, forKey: 123)
        cache.set(item: 234, forKey: 234)
        cache.set(item: 345, forKey: 345)
        cache.set(item: 456, forKey: 456)

        cache.countLimit = 2

        XCTAssert(cache.count == 2)
    }

    func testEmptyEviction() {
        // Make sure that an eviction on an empty dictionary doesn't crash
        let cache = LRUCache()
        cache.evictItems()
    }

    func testObjCObjects() {
        let cache = LRUCache()

        let boxedInt = NSNumber(value: 42)
        cache.set(item: boxedInt, forKey: "Answer")

        guard let answer: NSNumber = cache.item(forKey: "Answer") else {
            XCTFail("Expected an NSNumber object")
            return
        }
        XCTAssert(answer.intValue == 42)
    }
}

private struct TestStruct {
    let name: String
    let value: Int
}

private enum TestEnum {
    case abc
    case def(String)
    case ghi(Int)
}
