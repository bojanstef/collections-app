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
    func upload(credits: Credit, result: @escaping ((Result<Void, Error>) -> Void))
    func signOut() throws
}

final class SettingsInteractor {
    fileprivate let networkAccess: SettingsAccessing
    fileprivate let inAppStore: InAppStoreAccessing

    init(networkAccess: SettingsAccessing, inAppStore: InAppStoreAccessing) {
        self.networkAccess = networkAccess
        self.inAppStore = inAppStore
    }
}

extension SettingsInteractor: SettingsInteractable {
    func fetchProducts(result: @escaping ((Result<(credits: [Credit], maxAccounts: [MaxAccount]), Error>) -> Void)) {
        inAppStore.fetchProducts(result: result)
    }

    func purchase(credits: Credit, result: @escaping ((Result<Void, Error>) -> Void)) {
        inAppStore.purchase(credits: credits, result: result)
    }

    func upload(credits: Credit, result: @escaping ((Result<Void, Error>) -> Void)) {
        networkAccess.upload(credits: credits, result: result)
    }

    func signOut() throws {
        try networkAccess.signOut()
    }
}
