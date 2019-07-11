//
//  AuthPresenter.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol AuthPresentable {}

final class AuthPresenter {
    fileprivate weak var moduleDelegate: AuthModuleDelegate?
    fileprivate let interactor: AuthInteractable

    init(moduleDelegate: AuthModuleDelegate?, interactor: AuthInteractable) {
        self.moduleDelegate = moduleDelegate
        self.interactor = interactor
    }
}

extension AuthPresenter: AuthPresentable {}
