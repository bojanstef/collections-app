//
//  AuthPresenter.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol AuthPresentable {
    func navigateToLogin()
    func signIn(withEmail email: String, completion: @escaping ((Error?) -> Void))
    func createUser(withEmail email: String, password: String, completion: @escaping ((Error?) -> Void))
}

final class AuthPresenter {
    fileprivate weak var moduleDelegate: AuthModuleDelegate?
    fileprivate let interactor: AuthInteractable

    init(moduleDelegate: AuthModuleDelegate?, interactor: AuthInteractable) {
        self.moduleDelegate = moduleDelegate
        self.interactor = interactor
    }
}

extension AuthPresenter: AuthPresentable {
    func navigateToLogin() {
        moduleDelegate?.navigateToLogin()
    }

    func signIn(withEmail email: String, completion: @escaping ((Error?) -> Void)) {
        interactor.signIn(withEmail: email, completion: completion)
    }

    func createUser(withEmail email: String, password: String, completion: @escaping ((Error?) -> Void)) {
        interactor.createUser(withEmail: email, password: password, completion: completion)
    }
}
