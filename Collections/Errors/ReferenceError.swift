//
//  ReferenceError.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

enum ReferenceError: LocalizedError {
    case type(Any?)

    var errorDescription: String? {
        switch self {
        case .type(let value): return "No reference to type \(value)"
        }
    }
}
