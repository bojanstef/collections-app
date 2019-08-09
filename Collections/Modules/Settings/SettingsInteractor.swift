//
//  SettingsInteractor.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-04.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import StoreKit
import Foundation

protocol SettingsInteractable {
    func fetchProducts(ofType type: ProductIDs, result: @escaping ((Result<[SKProduct], Error>) -> Void))
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
    func fetchProducts(ofType type: ProductIDs, result: @escaping ((Result<[SKProduct], Error>) -> Void)) {
        inAppStore.fetchProducts(ofType: type, result: result)
    }

    func signOut() throws {
        try networkAccess.signOut()
    }
}
