//
//  ExtensionError.swift
//  Save Account
//
//  Created by Bojan Stefanovic on 2019-08-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

enum ExtensionError: LocalizedError {
    case noContextItem
    case noMedia
    case embedURL

    var errorDescription: String? {
        switch self {
        case .noContextItem: return "Empty extensionContext items"
        case .noMedia: return "Empty attachments for extensionItem"
        case .embedURL: return "Could not initialize Instagram OEmbed URL"
        }
    }
}
