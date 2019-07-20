//
//  Colletion+Modellable.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

extension Collection where Element: Modellable {
    static func decode(from data: Data) throws -> [Element] {
        let array = try Element.jsonDecoder.decode([Element].self, from: data)
        return array
    }
}
