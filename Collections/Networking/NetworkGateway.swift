//
//  NetworkGateway.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

final class NetworkGateway {}

extension NetworkGateway: AuthAccessing {}

//extension NetworkGateway: SignupServiceable {
//    func checkIsUserLoggedIn(completion: @escaping ((Bool) -> Void)) {
//        completion(Auth.auth().currentUser != nil)
//    }
//}

//extension NetworkGateway: EmailAuthServiceable {}
//extension NetworkGateway: MyProfileServiceable {
//    func logout() {
//        do {
//            try Auth.auth().signOut()
//        } catch {
//            print()
//        }
//    }
//}
