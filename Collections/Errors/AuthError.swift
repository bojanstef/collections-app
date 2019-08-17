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
    case invalidEmail
    case emptyPassword

    var errorDescription: String? {
        switch self {
        case .noUser: return "You are not signed in"
        case .invalidEmail: return "This is not a valid email"
        case .emptyPassword: return "Your password must be more than 8 letters"
        }
    }
}
