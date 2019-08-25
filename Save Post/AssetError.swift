//
//  AssetError.swift
//  Save Post
//
//  Created by Bojan Stefanovic on 2019-08-23.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

enum AssetError: LocalizedError {
    case noPlaceholder
    case noCollectionChangeRequest

    var errorDescription: String? {
        switch self {
        case .noPlaceholder: return "No placeholder for created asset"
        case .noCollectionChangeRequest: return "Could not instantiate asset collection change request"
        }
    }
}
