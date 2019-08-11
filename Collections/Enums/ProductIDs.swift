//
//  ProductIDs.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

enum ProductIDs {
    case credit
    case accountMax

    enum Credit: String, CaseIterable {
        case ninetyTwo =    "xyz.bojan.Collections.92credits"
        case fourtyFive =   "xyz.bojan.Collections.credits.45"
        case twentyTwo =    "xyz.bojan.Collections.22credits"
        case ten =          "xyz.bojan.Collections.10credits"

        var intValue: Int {
            switch self {
            case .ninetyTwo:    return 92
            case .fourtyFive:   return 45
            case .twentyTwo:    return 22
            case .ten:          return 10
            }
        }

        var extraCredits: Int {
            switch self {
            case .ninetyTwo:    return 12
            case .fourtyFive:   return 5
            case .twentyTwo:    return 2
            case .ten:          return 0
            }
        }

        var percentSavings: Int {
            switch self {
            case .ninetyTwo:    return 15
            case .fourtyFive:   return 13
            case .twentyTwo:    return 10
            case .ten:          return 0
            }
        }

        static var rawValues: Set<String> {
            return Set(allCases.map(\.rawValue))
        }
    }

    enum AccountMax: String, CaseIterable {
        case ten = "xyz.bojan.Collections.maxAccounts.10more"

        static var rawValues: Set<String> {
            return Set(allCases.map(\.rawValue))
        }
    }

    static var allRawValues: Set<String> {
        return Credit.rawValues.union(AccountMax.rawValues)
    }
}
