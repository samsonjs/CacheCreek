# CacheCreek

### Forked from [CacheIsKing]()

`CacheCreek` provides an an LRU cache that allows you to store any item, including objects, pure Swift structs, enums (with associated values), etc. Simply put, it's designed to act like an `NSCache` for everything, including Swift variables.

![Swift version 3.0](https://img.shields.io/badge/Swift-3.0-brightgreen.svg?style=flat)] ![version 0.2.0 on Carthage](https://img.shields.io/badge/Carthage-0.2.0-brightgreen.svg?style=flat) [![MIT License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://sjs.mit-license.org)

## Features

- Simply set, get, and remove items based on any key that is `Hashable`
- The cache is cleared when the app receives a memory warning
- Similar to `NSCache`, the cache is cleared when the app enters the background
- Subscripts are supported for `String`, `Int`, and `Float` keys
- `itemForKey` uses generics so you don't have to cast the return value when the type is inferred correctly
- Similar to `NSCache`, the cache can have a `countLimit` set to ensure that the cache doesn't get too large

## Requirements

- iOS 8.0+
- tvOS 9.0+
- Xcode 7+

## Installation using Carthage

Add this to your `Cartfile`:

```
github "samsonjs/CacheCreek"
```

## Usage

Simply use the `LRUCache` class similar to how you'd use a `NSCache`. Using the `setItem` and `itemForKey` methods allow you to use type inference to get the values you want.

```swift
let cache = LRUCache()
cache.set(item: 123, forKey: "123")

if let item: Int = cache.item(forKey: 456) {
	doSomethingWithItem(item)
}
```

You can also use subscripts to set/get items from the cache. Unfortunately since Swift doesn't support subscript methods with generics yet, you'll have to cast your items as necessary. Also currently only `String`, `Int`, and `Float` keys are supported:

```swift
let cache = LRUCache()
cache["123"] = 123

if let item = cache[456] as? Int {
	doSomethingWithItem(item)
}
```

The `LRUCache` also has a `countLimit` property, which allows you to set the maximum number of items in the cache.

```swift
let cache = LRUCache()
cache.countLimit = 2

cache[123] = 123
cache[234] = 234
cache[345] = 345

print("\(cache.count)") // shows a count of 2
```

## TODO

- Update with better subscript support once Swift supports subscripts with generics


# License

Copyright (c) 2015 Christopher Luu [MIT License](https://github.com/nuudles/CacheIsKing/blob/f93527d8ccc3f88b2e0697e9fd78be28d40a3a26/LICENSE)

Copyright &copy; 2016 Sami Samhuri  [MIT License](https://sjs.mit-license.org)
