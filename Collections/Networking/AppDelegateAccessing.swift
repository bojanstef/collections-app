//
//  AppDelegateAccessing.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-14.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol AppDelegateAccessing {
    func signIn(withEmailSignupLink link: String, completion: @escaping ((Result<Bool, Error>) -> Void))
    func handleFirebaseUniversalLink(_ url: URL, completion: @escaping ((Result<URL, Error>) -> Void)) -> Bool
}
