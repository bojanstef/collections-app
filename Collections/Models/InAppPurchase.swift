//
//  InAppPurchase.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-08.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

enum InAppPurchaseType: String, CustomStringConvertible {
    case availableProducts
    case invalidProductIdentifiers
    case purchased
    case restored
    case download
    case originalTransaction
    case productIdentifier
    case transactionDate
    case transactionIdentifier

    var description: String {
        return rawValue
    }
}

struct InAppPurchase {
    let type: InAppPurchaseType
    let elements: [Any]
}
