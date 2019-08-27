//
//  ProductIDs.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

enum ProductIDs {
    case accountMax

    enum AccountMax: String, CaseIterable {
        case hundred =      "xyz.bojan.Collections.maxAccounts.100more"
        case unlimited =    "xyz.bojan.Collections.maxAccounts.unlimited"

        var intValue: Int {
            switch self {
            case .hundred:      return 100
            case .unlimited:    return .max
            }
        }

        static var rawValues: Set<String> {
            return Set(allCases.map(\.rawValue))
        }
    }
}
