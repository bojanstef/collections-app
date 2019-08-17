//
//  LoginInteractor.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-16.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol LoginInteractable {
    func signIn(withEmail email: String, password: String, completion: @escaping ((Error?) -> Void))
}

final class LoginInteractor {
    fileprivate let networkAccess: LoginAccessing

    init(networkAccess: LoginAccessing) {
        self.networkAccess = networkAccess
    }
}

extension LoginInteractor: LoginInteractable {
    func signIn(withEmail email: String, password: String, completion: @escaping ((Error?) -> Void)) {
        networkAccess.signIn(withEmail: email, password: password, completion: completion)
    }
}
