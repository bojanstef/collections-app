//
//  CreditError.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-13.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

enum CreditError: LocalizedError {
    case notEnough

    var errorDescription: String? {
        switch self {
        case .notEnough: return "No credits left"
        }
    }
}
