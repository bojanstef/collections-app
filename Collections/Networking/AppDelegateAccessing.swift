//
//  AppDelegateAccessing.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-14.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol AppDelegateAccessing {
    var userID: String { get }
    func signIn(withEmailSignupLink link: String, result: @escaping ((Result<Void, Error>) -> Void))
}
