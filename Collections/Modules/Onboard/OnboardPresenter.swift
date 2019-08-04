//
//  OnboardPresenter.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-02.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol OnboardPresentable {
    func navigateToAuth()
}

final class OnboardPresenter {
    fileprivate weak var moduleDelegate: OnboardModuleDelegate?
    fileprivate let interactor: OnboardInteractable

    init(moduleDelegate: OnboardModuleDelegate?, interactor: OnboardInteractable) {
        self.moduleDelegate = moduleDelegate
        self.interactor = interactor
    }
}

extension OnboardPresenter: OnboardPresentable {
    func navigateToAuth() {
        moduleDelegate?.navigateToAuth()
    }
}
