//
//  AccountError.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

enum AccountError: LocalizedError {
    case duplicate(String?)

    var errorDescription: String? {
        switch self {
        case .duplicate(let username):
            if let username = username {
                return "Account @\(username) is already saved"
            } else {
                return "This accounts is already saved"
            }
        }
    }
}
