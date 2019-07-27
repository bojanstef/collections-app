//
//  Collection+Modellable.swift
//  CollectionsKit
//
//  Created by Bojan Stefanovic on 2019-07-26.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

extension Collection where Element: Modellable {
    public static func decode(from data: Data) throws -> [Element] {
        let array = try Element.jsonDecoder.decode([Element].self, from: data)
        return array
    }
}
