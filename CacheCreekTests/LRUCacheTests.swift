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
        XCTAssert(cache.item(forKey: floatKey) as Double? == .Some(123.456))

        cache[floatKey] = 456.789
        XCTAssert(cache.count == 1)
        XCTAssert(cache[floatKey] as? Double == .Some(456.789))

        cache.set(item: "123.456", forKey: "123.456")
        XCTAssert(cache.count == 2)
        XCTAssert(cache.item(forKey: "123.456") as String? == .Some("123.456"))

        let boolKey = true
        cache.set(item: true, forKey: boolKey)
        XCTAssert(cache.count == 3)
        XCTAssert(cache.item(forKey: boolKey) as Bool? == .Some(true))

        cache.removeItem(forKey: boolKey)
        XCTAssert(cache.count == 2)
        XCTAssert(cache.item(forKey: boolKey) as Bool? == .None)
    }

    func testSettingAndGettingEnum() {
        let cache = LRUCache()
        cache["ABC"] = TestEnum.ABC
        cache["DEF"] = TestEnum.DEF("BlahBlahBlah")
        cache["GHI"] = TestEnum.GHI(-500)

        guard let abc: TestEnum = cache.item(forKey: "ABC"),
            def: TestEnum = cache.item(forKey: "DEF"),
            ghi: TestEnum = cache.item(forKey: "GHI")
            else {
                XCTFail()
                return
            }
        switch (abc, def, ghi) {
        case (.ABC, .DEF(let stringValue), .GHI(let intValue)):
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
        XCTAssert(cache[123] as? Int == .Some(123))
        XCTAssert(cache.count == 1)

        cache[123] = nil
        XCTAssert(cache[123] as? Int == .None)
        XCTAssert(cache.count == 0)

        // String subscript
        cache["123"] = 123
        XCTAssert(cache["123"] as? Int == .Some(123))
        XCTAssert(cache.count == 1)

        cache["123"] = nil
        XCTAssert(cache["123"] as? Int == .None)
        XCTAssert(cache.count == 0)

        // Float subscript
        let floatKey: Float = 3.14
        cache[floatKey] = 123
        XCTAssert(cache[floatKey] as? Int == .Some(123))
        XCTAssert(cache.count == 1)
        
        cache[floatKey] = nil
        XCTAssert(cache[floatKey] as? Int == .None)
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

        NSNotificationCenter.defaultCenter().postNotificationName(UIApplicationDidReceiveMemoryWarningNotification, object: UIApplication.sharedApplication())

        XCTAssert(cache.count == 0)

        cache.set(item: 123, forKey: 123)
        cache.set(item: 234, forKey: 234)
        cache.set(item: 345, forKey: 345)
        cache.set(item: 456, forKey: 456)

        XCTAssert(cache.count == 4)

        NSNotificationCenter.defaultCenter().postNotificationName(UIApplicationDidEnterBackgroundNotification, object: UIApplication.sharedApplication())

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

        let oldCache = NSCache()
        cache.set(item: oldCache, forKey: "InceptionCache")

        guard let _: NSCache = cache.item(forKey: "InceptionCache") else {
            XCTFail("Expected an NSCache object")
            return
        }
    }
}

private struct TestStruct {
    let name: String
    let value: Int
}

private enum TestEnum {
    case ABC
    case DEF(String)
    case GHI(Int)
}
