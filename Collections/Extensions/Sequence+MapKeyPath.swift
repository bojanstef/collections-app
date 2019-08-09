//
//  Sequence+MapKeyPath.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-08.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

extension Sequence {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }
}
