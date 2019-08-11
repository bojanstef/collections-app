//
//  Credit.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-10.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation
import StoreKit

struct Credit {
    let product: SKProduct
    let creditType: ProductIDs.Credit

    init?(product: SKProduct) {
        guard let creditType = ProductIDs.Credit(rawValue: product.productIdentifier) else { return nil }
        self.creditType = creditType
        self.product = product
    }
}

extension Credit: Comparable {
    static func < (lhs: Credit, rhs: Credit) -> Bool {
        return lhs.product.price.doubleValue < rhs.product.price.doubleValue
    }
}
