//
//  EmailError.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

enum EmailError: LocalizedError {
    case invalid

    var localizedDescription: String {
        switch self {
        case .invalid: return "This is not a valid email."
        }
    }
}
