//
//  DoublyLinkedList.swift
//  CacheCreek
//
//  Created by Sami Samhuri on 2016-08-10.
//

struct DoublyLinkedList {

    typealias Node = DoublyLinkedListNode

    fileprivate(set) var head: Node?

    fileprivate(set) var tail: Node?

    fileprivate(set) var count = 0

    var isEmpty: Bool {
        return head == nil
    }

    mutating func prepend(key: AnyKey, value: Any) -> Node {
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

    mutating func append(key: AnyKey, value: Any) -> Node {
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

    mutating func remove(node: Node) {
        if node === head {
            head = node.next
        }
        if node === tail {
            tail = node.prev
        }

        node.prev?.next = node.next
        node.next?.prev = node.prev
        node.next = nil
        node.prev = nil
        count -= 1
    }

    mutating func moveToHead(node: Node) {
        remove(node: node)
        let _ = prepend(key: node.key, value: node.value)
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
