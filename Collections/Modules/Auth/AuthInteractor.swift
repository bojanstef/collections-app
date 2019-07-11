//
//  AuthInteractor.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol AuthInteractable {}

final class AuthInteractor {
    fileprivate let networkAccess: AuthAccessing

    init(networkAccess: AuthAccessing) {
        self.networkAccess = networkAccess
    }
}

extension AuthInteractor: AuthInteractable {}
