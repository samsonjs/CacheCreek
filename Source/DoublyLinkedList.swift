//
//  DoublyLinkedList.swift
//  CacheCreek
//
//  Created by Sami Samhuri on 2016-08-10.
//

import Dispatch
import UIKit

extension NSIndexPath {
    override public var description: String {
        return "{\(section),\(item)}"
    }
}

struct DoublyLinkedList {

    typealias Node = DoublyLinkedListNode

    private(set) var head: Node?

    private(set) var tail: Node?

    private(set) var count = 0

    var isEmpty: Bool {
        return head == nil
    }

    private func log(m: String) {
        print("[List] \(m) (count=\(count) head=\(head?.description) tail=\(tail?.description))")
    }

    private func look() {
        print("new look: \(description)")
    }

    var description: String {
        var nodeDescriptions: [String] = []
        var node = head
        var prev: Node? = nil
        while node != nil {
            if prev !== node!.prev {
                fatalError("prev(\(prev?.description)) !== node.prev(\(node!.prev?.description))")
            }
            nodeDescriptions.append("[\(node!.key.description)]")
            prev = node
            node = node!.next
            if prev!.next !== node {
                fatalError("prev.next(\(prev!.next?.description)) !== node(\(node?.description))")
            }
        }
        if nodeDescriptions.count > 10 {
            let firstRange = nodeDescriptions.startIndex..<nodeDescriptions.startIndex.advancedBy(6)
            let lastRange = nodeDescriptions.endIndex.advancedBy(-6)..<nodeDescriptions.endIndex
            var truncated = Array(nodeDescriptions[firstRange])
            truncated.append("...")
            truncated.appendContentsOf(nodeDescriptions[lastRange])
            nodeDescriptions = truncated
        }
        return "<List:\(nodeDescriptions.joinWithSeparator(" -> "))>"
    }

    mutating func prepend(key key: AnyKey, value: Any) -> Node {
        log("prepend key \(key.description)")
        let node = Node(key: key, value: value)
        node.next = head
        head?.prev = node
        head = node
        if tail == nil {
            tail = node
        }
        count += 1
        look()
        return node
    }

    mutating func append(key key: AnyKey, value: Any) -> Node {
        log("append key \(key.description)")
        let node = Node(key: key, value: value)
        node.prev = tail
        tail?.next = node
        tail = node
        if head == nil {
            head = node
        }
        count += 1
        look()
        return node
    }

    mutating func removeAll() {
        log("remove all")
        head = nil
        tail = nil
        count = 0
        look()
    }

    mutating func removeLast() -> Node? {
        log("remove last")
        if let node = tail {
            remove(node: node)
            look()
            return node
        }
        look()
        return nil
    }

    mutating func remove(node node: Node) {
        log("remove node \(node.description)")
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
        if head == nil && tail == nil && count > 0 {
            log("removal fucked up: \(node.description)")
            fatalError("fucked")
        }
        look()
    }

    mutating func moveToHead(node node: Node) {
        log("move to head: \(node.description)")
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

    var description: String {
        return "<Node: key=\(key.description) prev=\(prev?.key.description) next=\(next?.key.description)>"
    }

}
