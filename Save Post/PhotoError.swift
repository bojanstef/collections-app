//
//  PhotoError.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-23.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

enum PhotoError: LocalizedError {
    case creationFailure

    var errorDescription: String? {
        switch self {
        case .creationFailure: return "Collection creation request failed"
        }
    }
}
