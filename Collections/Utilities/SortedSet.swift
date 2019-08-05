//
//  SortedSet.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-04.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

typealias SortedSetElement = Hashable & Comparable

final class SortedSet<Element: SortedSetElement> {
    fileprivate var hashSet: Set<Element>
    fileprivate var array: [Element]

    init() {
        self.hashSet = []
        self.array = []
    }

    init(_ array: [Element]) {
        self.hashSet = Set(array)
        self.array = Array(hashSet).sorted()
    }

    var count: Int {
        return array.count
    }

    func contains(_ element: Element) -> Bool {
        return hashSet.contains(element)
    }

    @discardableResult
    func append(_ newValue: Element) -> Bool {
        if hashSet.insert(newValue).inserted {
            array = Array(hashSet).sorted()
            return true
        } else {
            return false
        }
    }

    @discardableResult
    func remove(at position: Int) -> Element {
        let removed = array.remove(at: position)
        self.hashSet = Set(array)
        return removed
    }

    subscript(_ index: Int) -> Element {
        return array[index]
    }
}
