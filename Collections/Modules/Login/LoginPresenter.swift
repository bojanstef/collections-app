//
//  LoginPresenter.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-16.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol LoginPresentable {
    func signIn(withEmail email: String, password: String, completion: @escaping ((Error?) -> Void))
}

final class LoginPresenter {
    fileprivate weak var moduleDelegate: LoginModuleDelegate?
    fileprivate let interactor: LoginInteractable

    init(moduleDelegate: LoginModuleDelegate?, interactor: LoginInteractable) {
        self.moduleDelegate = moduleDelegate
        self.interactor = interactor
    }
}

extension LoginPresenter: LoginPresentable {
    func signIn(withEmail email: String, password: String, completion: @escaping ((Error?) -> Void)) {
        interactor.signIn(withEmail: email, password: password, completion: completion)
    }
}
