# CacheCreek

### Forked from [CacheIsKing]()

`CacheCreek` provides an an LRU cache that allows you to store any item, including objects, pure Swift structs, enums (with associated values), etc. Simply put, it's designed to act like an `NSCache` for everything, including Swift variables.

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

## Installation using CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

Because `CacheCreek` is written in Swift, you must use frameworks.

To integrate `CacheCreek` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'CacheCreek'
```

Then, run the following command:

```bash
$ pod install
```

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

[MIT License](https://sjs.mit-license.org)
