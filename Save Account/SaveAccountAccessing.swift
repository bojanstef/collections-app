//
//  SaveAccountAccessing.swift
//  Save Account
//
//  Created by Bojan Stefanovic on 2019-07-25.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol SaveAccountAccessing {
    var userID: String { get }
    func getAccountsCount(result: @escaping ((Result<Int, Error>) -> Void))
    func getInstagramEmbedded(fromURL url: URL, result: @escaping ((Result<InstagramEmbedded, Error>) -> Void))
    func addAccount(_ account: Account, result: @escaping ((Result<Account, Error>) -> Void))
}
