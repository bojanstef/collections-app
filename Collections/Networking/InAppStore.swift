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
    case credits
    case accountsMax

    private enum Credits: String, CaseIterable {
        case ten = "xyz.bojan.Collections.10credits"
        case twentyTwo = "xyz.bojan.Collections.22credits"
        case fourtyFive = "xyz.bojan.Collections.45credits"
        case ninety = "xyz.bojan.Collections.90credits"
    }

    private enum AccountsMax: String, CaseIterable {
        case twentyFive = "xyz.bojan.Collections.25accounts"
    }

    var rawValues: Set<String> {
        switch self {
        case .credits:
            return Set(Credits.allCases.map(\.rawValue))
        case .accountsMax:
            return Set(AccountsMax.allCases.map(\.rawValue))
        }
    }
}

protocol InAppStoreAccessing {
    func fetchProducts(ofType type: ProductIDs, result: @escaping ((Result<[SKProduct], Error>) -> Void))
}

final class InAppStore: NSObject {
    fileprivate var productRequest: SKProductsRequest?
    fileprivate var productResult: ((Result<[SKProduct], Error>) -> Void)?
}

extension InAppStore: InAppStoreAccessing {
    func fetchProducts(ofType type: ProductIDs, result: @escaping ((Result<[SKProduct], Error>) -> Void)) {
        productResult = result
        productRequest = SKProductsRequest(productIdentifiers: type.rawValues)
        productRequest?.delegate = self
        productRequest?.start()
    }
}

extension InAppStore: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard !response.products.isEmpty else {
            // TODO: - Custom error
            productResult?(.failure(NSError(domain: "No products", code: 0, userInfo: nil)))
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.productResult?(.success(response.products))
        }
    }
}

extension InAppStore: SKRequestDelegate {
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.productResult?(.failure(error))
        }
    }
}
