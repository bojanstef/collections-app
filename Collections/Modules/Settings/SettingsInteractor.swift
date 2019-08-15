//
//  SettingsInteractor.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-04.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol SettingsInteractable {
    func fetchProducts(result: @escaping ((Result<(credits: [Credit], maxAccounts: [MaxAccount]), Error>) -> Void))
    func purchase(credits: Credit, result: @escaping ((Result<Void, Error>) -> Void))
    func purchase(maxAccounts: MaxAccount, result: @escaping ((Result<Void, Error>) -> Void))
    func restoreSubscription(_ result: @escaping ((Result<Void, Error>) -> Void))
    func signOut() throws
}

final class SettingsInteractor {
    fileprivate let networkAccess: SettingsAccessing
    fileprivate let inAppStore: InAppStoreAccessing
    fileprivate let keychainStorage: KeychainAccessing

    init(networkAccess: SettingsAccessing, inAppStore: InAppStoreAccessing, keychainStorage: KeychainAccessing) {
        self.networkAccess = networkAccess
        self.inAppStore = inAppStore
        self.keychainStorage = keychainStorage
    }
}

extension SettingsInteractor: SettingsInteractable {
    func fetchProducts(result: @escaping ((Result<(credits: [Credit], maxAccounts: [MaxAccount]), Error>) -> Void)) {
        inAppStore.fetchProducts(result: result)
    }

    func purchase(credits: Credit, result: @escaping ((Result<Void, Error>) -> Void)) {
        inAppStore.purchase(product: credits.product) { [weak self] purchaseResult in
            switch purchaseResult {
            case .success:
                self?.keychainStorage.save(credits, result: result)
            case .failure(let error):
                result(.failure(error))
            }
        }
    }

    func purchase(maxAccounts: MaxAccount, result: @escaping ((Result<Void, Error>) -> Void)) {
        inAppStore.purchase(product: maxAccounts.product) { [weak self] purchaseResult in
            switch purchaseResult {
            case .success:
                self?.keychainStorage.save(maxAccounts, result: result)
            case .failure(let error):
                result(.failure(error))
            }
        }
    }

    func restoreSubscription(_ result: @escaping ((Result<Void, Error>) -> Void)) {
        inAppStore.restoreSubscription(result)
    }

    func signOut() throws {
        try networkAccess.signOut()
    }
}
