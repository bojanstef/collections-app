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
    func purchase(credits: Credit, result: @escaping ((Result<Void, Error>) -> Void))
}

final class InAppStore: NSObject {
    fileprivate var productRequest: SKProductsRequest?
    fileprivate var productsResult: ((Result<[SKProduct], Error>) -> Void)!
    fileprivate var purchaseResult: ((Result<Void, Error>) -> Void)!

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
}

extension InAppStore: InAppStoreAccessing {
    func fetchProducts(ofType type: ProductIDs, result: @escaping ((Result<[SKProduct], Error>) -> Void)) {
        productsResult = result
        productRequest = SKProductsRequest(productIdentifiers: type.rawValues)
        productRequest?.delegate = self
        productRequest?.start()
    }

    func purchase(credits: Credit, result: @escaping ((Result<Void, Error>) -> Void)) {
        purchaseResult = result
        let payment = SKPayment(product: credits.product)
        SKPaymentQueue.default().add(payment)
    }
}

extension InAppStore: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard !response.products.isEmpty else {
            // TODO: - Custom error
            productsResult(.failure(NSError(domain: "No products", code: 0, userInfo: nil)))
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.productsResult(.success(response.products))
        }
    }
}

extension InAppStore: SKRequestDelegate {
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.productsResult(.failure(error))
        }
    }
}

extension InAppStore: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            switch transaction.transactionState {
            case .purchased:    complete(transaction)
            case .failed:       fail(transaction)
            case .restored:     restore(transaction)
            case .deferred:     break
            case .purchasing:   break
            @unknown default:
                let domain = "Unknown or new transaction state \(transaction.transactionState)"
                let error = NSError(domain: domain, code: 0, userInfo: nil) // TODO: - Custom error
                purchaseResult(.failure(error))
            }
        }
    }
}

fileprivate extension InAppStore {
    func complete(_ transaction: SKPaymentTransaction) {
        log.debug("Purchase finished")
        purchaseResult(.success)
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    func restore(_ transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else {
            // TODO: - Custom error
            purchaseResult(.failure(NSError(domain: "No product to restore", code: 0, userInfo: nil)))
            return
        }

        log.debug(productIdentifier)
        purchaseResult(.success)
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    func fail(_ transaction: SKPaymentTransaction) {
        if let skError = transaction.error as? SKError, skError.code == .paymentCancelled {
            log.info("Purchase cancelled")
            purchaseResult(.failure(skError))
        } else if let error = transaction.error {
            purchaseResult(.failure(error))
        } else {
            log.debug("Purchase failed without error?")
            // TODO: - Custom error
            purchaseResult(.failure(NSError(domain: "Unknown error", code: 0, userInfo: nil)))
        }

        SKPaymentQueue.default().finishTransaction(transaction)
    }
}
