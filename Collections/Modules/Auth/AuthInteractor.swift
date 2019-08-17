//
//  AuthInteractor.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol AuthInteractable {
    func signIn(withEmail email: String, completion: @escaping ((Error?) -> Void))
    func createUser(withEmail email: String, password: String, completion: @escaping ((Error?) -> Void))
}

final class AuthInteractor {
    fileprivate let networkAccess: AuthAccessing

    init(networkAccess: AuthAccessing) {
        self.networkAccess = networkAccess
    }
}

extension AuthInteractor: AuthInteractable {
    func signIn(withEmail email: String, completion: @escaping ((Error?) -> Void)) {
        networkAccess.signIn(withEmail: email, completion: completion)
    }

    func createUser(withEmail email: String, password: String, completion: @escaping ((Error?) -> Void)) {
        networkAccess.createUser(withEmail: email, password: password, completion: completion)
    }
}
