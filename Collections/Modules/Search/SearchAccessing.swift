//
//  SearchAccessing.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol SearchAccessing {
    func scrapeAccounts(result: @escaping ((Result<Void, Error>) -> Void))
}
