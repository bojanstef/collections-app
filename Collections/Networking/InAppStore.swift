//
//  InAppStore.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-06.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import StoreKit
import Foundation

enum ProductIDs {
    case credit
    case accountMax

    enum Credit: String, CaseIterable {
        case ninetyTwo = "xyz.bojan.Collections.92credits"
        case fourtyFive = "xyz.bojan.Collections.credits.45"
        case twentyTwo = "xyz.bojan.Collections.22credits"
        case ten = "xyz.bojan.Collections.10credits"

        var intValue: Int {
            switch self {
            case .ninetyTwo: return 92
            case .fourtyFive: return 45
            case .twentyTwo: return 22
            case .ten: return 10
            }
        }

        var extraCredits: Int {
            switch self {
            case .ninetyTwo: return 12
            case .fourtyFive: return 5
            case .twentyTwo: return 2
            case .ten: return 0
            }
        }

        var percentSavings: Int {
            switch self {
            case .ninetyTwo: return 15
            case .fourtyFive: return 13
            case .twentyTwo: return 10
            case .ten: return 0
            }
        }

        static var rawValues: Set<String> {
            return Set(allCases.map(\.rawValue))
        }
    }

    enum AccountMax: String, CaseIterable {
        case twentyFive = "xyz.bojan.Collections.25accounts"

        static var rawValues: Set<String> {
            return Set(allCases.map(\.rawValue))
        }
    }

    var rawValues: Set<String> {
        switch self {
        case .accountMax: return AccountMax.rawValues
        case .credit: return Credit.rawValues
        }
    }
}

protocol InAppStoreAccessing {
    func fetchProducts(ofType type: ProductIDs, result: @escaping ((Result<[SKProduct], Error>) -> Void))
}

final class InAppStore: NSObject {
    fileprivate var productRequest: SKProductsRequest?
    fileprivate var productsResult: ((Result<[SKProduct], Error>) -> Void)?
}

extension InAppStore: InAppStoreAccessing {
    func fetchProducts(ofType type: ProductIDs, result: @escaping ((Result<[SKProduct], Error>) -> Void)) {
        productsResult = result
        productRequest = SKProductsRequest(productIdentifiers: type.rawValues)
        productRequest?.delegate = self
        productRequest?.start()
    }
}

extension InAppStore: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard !response.products.isEmpty else {
            // TODO: - Custom error
            productsResult?(.failure(NSError(domain: "No products", code: 0, userInfo: nil)))
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.productsResult?(.success(response.products))
        }
    }
}

extension InAppStore: SKRequestDelegate {
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.productsResult?(.failure(error))
        }
    }
}
