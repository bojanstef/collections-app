//
//  InAppStore.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-06.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import StoreKit
import Foundation

protocol InAppStoreAccessing {
    func fetchProducts(result: @escaping ((Result<(credits: [Credit], maxAccounts: [MaxAccount]), Error>) -> Void))
    func purchase(product: SKProduct, result: @escaping ((Result<Void, Error>) -> Void))
}

final class InAppStore: NSObject {
    fileprivate var productRequest: SKProductsRequest?
    fileprivate var productsResult: ((Result<(credits: [Credit], maxAccounts: [MaxAccount]), Error>) -> Void)!
    fileprivate var purchaseResult: ((Result<Void, Error>) -> Void)!

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
}

extension InAppStore: InAppStoreAccessing {
    func fetchProducts(result: @escaping ((Result<(credits: [Credit], maxAccounts: [MaxAccount]), Error>) -> Void)) {
        productsResult = result
        productRequest = SKProductsRequest(productIdentifiers: ProductIDs.allRawValues)
        productRequest?.delegate = self
        productRequest?.start()
    }

    func purchase(product: SKProduct, result: @escaping ((Result<Void, Error>) -> Void)) {
        purchaseResult = result
        let payment = SKPayment(product: product)
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
            let credits = response.products.compactMap { Credit(product: $0) }
            let maxAccounts = response.products.compactMap { MaxAccount(product: $0) }
            self.productsResult(.success((credits: credits, maxAccounts: maxAccounts)))
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
