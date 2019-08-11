//
//  MaxAccount.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation
import StoreKit

struct MaxAccount {
    let product: SKProduct
    let maxAccountType: ProductIDs.AccountMax

    init?(product: SKProduct) {
        guard let maxAccountType = ProductIDs.AccountMax(rawValue: product.productIdentifier) else { return nil }
        self.maxAccountType = maxAccountType
        self.product = product
    }
}

extension MaxAccount: Comparable {
    static func < (lhs: MaxAccount, rhs: MaxAccount) -> Bool {
        return lhs.product.price.doubleValue < rhs.product.price.doubleValue
    }
}
