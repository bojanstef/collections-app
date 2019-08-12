//
//  AuthError.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

enum AuthError: LocalizedError {
    case noUser

    var errorDescription: String? {
        switch self {
        case .noUser: return "You are not signed in"
        }
    }
}
