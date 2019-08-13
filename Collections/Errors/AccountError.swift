//
//  AccountError.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

enum AccountError: LocalizedError {
    case empty
    case maximumReached
    case duplicate(String?)
    case unknown

    var errorDescription: String? {
        switch self {
        case .empty:
            return "Account username is empty"
        case .maximumReached:
            return "Not enough accounts, you have to increase your limit"
        case .duplicate(let username):
            if let username = username {
                return "Account @\(username) is already saved"
            } else {
                return "This accounts is already saved"
            }
        case .unknown:
            return "Something happened, maybe try again?"
        }
    }
}
