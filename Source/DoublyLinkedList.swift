//
//  DoublyLinkedList.swift
//  CacheCreek
//
//  Created by Sami Samhuri on 2016-08-10.
//

struct DoublyLinkedList {

    typealias Node = DoublyLinkedListNode

    private(set) var head: Node?

    private(set) var tail: Node?

    private(set) var count = 0

    var isEmpty: Bool {
        return head == nil
    }

    mutating func prepend(key key: AnyKey, value: Any) -> Node {
        let node = Node(key: key, value: value)
        node.next = head
        head?.prev = node
        head = node
        if tail == nil {
            tail = node
        }
        count += 1
        return node
    }

    mutating func append(key key: AnyKey, value: Any) -> Node {
        let node = Node(key: key, value: value)
        node.prev = tail
        tail?.next = node
        tail = node
        if head == nil {
            head = node
        }
        count += 1
        return node
    }

    mutating func removeAll() {
        head = nil
        tail = nil
        count = 0
    }

    mutating func removeLast() -> Node? {
        if let node = tail {
            remove(node: node)
            return node
        }
        return nil
    }

    mutating func remove(node node: Node) {
        if let prev = node.prev {
            prev.next = node.next
        }
        else {
            head = node.next
        }
        if let next = node.next {
            next.prev = node.prev
        }
        else {
            tail = node.prev
        }
        node.next = nil
        node.prev = nil
        count -= 1
    }

    mutating func moveToHead(node node: Node) {
        remove(node: node)
        prepend(key: node.key, value: node.value)
    }

}

class DoublyLinkedListNode {

    let key: AnyKey

    let value: Any

    var next: DoublyLinkedListNode?

    weak var prev: DoublyLinkedListNode?

    init(key: AnyKey, value: Any) {
        self.key = key
        self.value = value
    }

}
