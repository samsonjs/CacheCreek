//
//  LRUCache.swift
//  CacheCreek
//
//  Created by Christopher Luu on 1/26/16.
// 
//  Modified to use LRU eviction by Sami Samhuri on 2016-08-10.
//

import Foundation

/// `LRUCache` is an LRU cache that can hold anything, including Swift structs, enums, and values.
/// It is designed to work similar to the `NSCache`, but with native Swift support.
///
public class LRUCache {
	// MARK: - Private variables
	/// An array of `NSNotificationCenter` observers that need to be removed upon deinitialization
	private var notificationObservers: [NSObjectProtocol] = []

    /// The list of cached items. Most recently used item at head, least recently used item at tail.
    private var items: DoublyLinkedList = DoublyLinkedList()

	/// Maps keys of cached items to nodes in the linked list.
	private var keyToNodeMap: [AnyKey:DoublyLinkedListNode] = [:]

	// MARK: - Public variables
	/// The number of items in the cache.
	public var count: Int {
		return items.count
	}

	/// The limit of the amount of items that can be held in the cache. This defaults to 0, which means there is no limit.
	public var countLimit: Int = 0 {
		didSet {
            assert(countLimit >= 0)
			evictItems()
		}
	}

	// MARK: - Initialization methods
	public init() {
		let removalBlock = { [unowned self] (_: NSNotification) in
			self.removeAllItems()
		}

		var notificationObserver = NSNotificationCenter.defaultCenter()
			.addObserverForName(UIApplicationDidReceiveMemoryWarningNotification,
				object: UIApplication.sharedApplication(),
				queue: nil,
				usingBlock: removalBlock)
		notificationObservers.append(notificationObserver)
		notificationObserver = NSNotificationCenter.defaultCenter()
			.addObserverForName(UIApplicationDidEnterBackgroundNotification,
				object: UIApplication.sharedApplication(),
				queue: nil,
				usingBlock: removalBlock)
		notificationObservers.append(notificationObserver)
	}

	deinit {
		notificationObservers.forEach {
			NSNotificationCenter.defaultCenter().removeObserver($0)
		}
	}

	// MARK: - Internal methods
	/// Evicts items if the `countLimit` has been reached.
	///
	func evictItems() {
        guard countLimit > 0 else { return }
        while items.count > countLimit {
            if let node = items.removeLast() {
                keyToNodeMap[node.key] = nil
            }
		}
	}

	// MARK: - Public methods
	/// Adds an item to the cache for any given `Hashable` key.
	///
	/// - parameter item: The item to be cached
	/// - parameter key: The key with which to cache the item
	///
	public func set<K: Hashable>(item item: Any, forKey key: K) {
        let key = AnyKey(key)
        if let existingNode = keyToNodeMap[key] {
            items.remove(node: existingNode)
        }
        let node = items.prepend(key: key, value: item)
        keyToNodeMap[key] = node
		evictItems()
	}

	/// Gets an item from the cache if it exists for a given `Hashable` key.
	/// This method uses generics to infer the type that should be returned.
	///
	/// Note: Even if an item exists for the key, but does not match the given type, it will return `nil`.
	///
	/// - parameter key: The key whose item should be fetched
	/// - returns: The item from the cache if it exists, or `nil` if an item could not be found
	///
	public func item<T, K: Hashable>(forKey key: K) -> T? {
        let key = AnyKey(key)
		if let node = keyToNodeMap[key], let item = node.value as? T {
            items.moveToHead(node: node)
			return item
		}
		return nil
	}

	/// Discards an item for a given `Hashable` key.
	///
	/// - parameter key: The key whose item should be removed
	///
	public func removeItem<K: Hashable>(forKey key: K) {
        let key = AnyKey(key)
        if let node = keyToNodeMap[key] {
            items.remove(node: node)
            keyToNodeMap[key] = nil
        }
	}

	/// Clears the entire cache.
	///
	public func removeAllItems() {
        items.removeAll()
		keyToNodeMap.removeAll()
	}

	// MARK: - Subscript methods
	// TODO: Consolidate these subscript methods once subscript generics with constraints are supported
	/// A subscript method that allows `Int` key subscripts.
	///
	public subscript(key: Int) -> Any? {
		get {
            return item(forKey: key)
		}
		set {
			if let newValue = newValue {
                set(item: newValue, forKey: key)
			}
			else {
                removeItem(forKey: key)
			}
		}
	}

	/// A subscript method that allows `Float` key subscripts.
	///
	public subscript(key: Float) -> Any? {
		get {
            return item(forKey: key)
		}
		set {
			if let newValue = newValue {
                set(item: newValue, forKey: key)
			}
			else {
                removeItem(forKey: key)
			}
		}
	}

	/// A subscript method that allows `String` key subscripts.
	///
	public subscript(key: String) -> Any? {
		get {
            return item(forKey: key)
		}
		set {
			if let newValue = newValue {
                set(item: newValue, forKey: key)
			}
			else {
                removeItem(forKey: key)
			}
		}
	}
}
