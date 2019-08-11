//
//  SKProduct+LocalizedPrice.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-10.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import StoreKit

extension SKProduct {
    fileprivate var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }

    var localizedPrice: String? {
        currencyFormatter.locale = priceLocale
        return currencyFormatter.string(from: price)
    }
}
