//
//  SettingsPresenter.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-04.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol SettingsPresentable {
    func fetchProducts(result: @escaping ((Result<(credits: [Credit], maxAccounts: [MaxAccount]), Error>) -> Void))
    func purchase(credits: Credit, start: (() -> Void), result: @escaping ((Result<Void, Error>) -> Void))
    func purchase(maxAccounts: MaxAccount, start: (() -> Void), result: @escaping ((Result<Void, Error>) -> Void))
    func restoreSubscription(_ result: @escaping ((Result<Void, Error>) -> Void))
    func signOut() throws
}

final class SettingsPresenter {
    fileprivate weak var moduleDelegate: SettingsModuleDelegate?
    fileprivate let interactor: SettingsInteractable

    init(moduleDelegate: SettingsModuleDelegate?, interactor: SettingsInteractable) {
        self.moduleDelegate = moduleDelegate
        self.interactor = interactor
    }
}

extension SettingsPresenter: SettingsPresentable {
    func fetchProducts(result: @escaping ((Result<(credits: [Credit], maxAccounts: [MaxAccount]), Error>) -> Void)) {
        interactor.fetchProducts(result: result)
    }

    func purchase(credits: Credit, start: (() -> Void), result: @escaping ((Result<Void, Error>) -> Void)) {
        start()
        interactor.purchase(credits: credits, result: result)
    }

    func purchase(maxAccounts: MaxAccount, start: (() -> Void), result: @escaping ((Result<Void, Error>) -> Void)) {
        start()
        interactor.purchase(maxAccounts: maxAccounts, result: result)
    }

    func restoreSubscription(_ result: @escaping ((Result<Void, Error>) -> Void)) {
        interactor.restoreSubscription(result)
    }

    func signOut() throws {
        try interactor.signOut()
    }
}
