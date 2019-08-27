//
//  IGBusinessAccount.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-25.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

struct IGBusinessAccount: Modellable {
    let id: String // Connected IG User ID
}

struct IGAccountContainer: Modellable {
    let instagramBusinessAccount: IGBusinessAccount
    let id: String // Facebook Page ID
}
