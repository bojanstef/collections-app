//
//  SettingsPresenter.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-04.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol SettingsPresentable {
    func fetchCredits(result: @escaping ((Result<[Credit], Error>) -> Void))
    func purchase(credits: Credit, start: (() -> Void), result: @escaping ((Result<Void, Error>) -> Void))
    func upload(credits: Credit, result: @escaping ((Result<Void, Error>) -> Void))
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
    func fetchCredits(result: @escaping ((Result<[Credit], Error>) -> Void)) {
        interactor.fetchCredits(result: result)
    }

    func purchase(credits: Credit, start: (() -> Void), result: @escaping ((Result<Void, Error>) -> Void)) {
        start()
        interactor.purchase(credits: credits, result: result)
    }

    func upload(credits: Credit, result: @escaping ((Result<Void, Error>) -> Void)) {
        interactor.upload(credits: credits, result: result)
    }

    func signOut() throws {
        try interactor.signOut()
    }
}
