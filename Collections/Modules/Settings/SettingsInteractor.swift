//
//  SettingsInteractor.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-04.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol SettingsInteractable {
    func fetchCredits(result: @escaping ((Result<[Credit], Error>) -> Void))
    func purchase(credits: Credit, result: @escaping ((Result<Void, Error>) -> Void))
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
    func fetchCredits(result: @escaping ((Result<[Credit], Error>) -> Void)) {
        inAppStore.fetchProducts(ofType: .credit) { productResult in
            switch productResult {
            case .success(let products):
                let credits = products.compactMap { Credit(product: $0) }
                result(.success(credits))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }

    func purchase(credits: Credit, result: @escaping ((Result<Void, Error>) -> Void)) {
        inAppStore.purchase(credits: credits, result: result)
    }

    func signOut() throws {
        try networkAccess.signOut()
    }
}
