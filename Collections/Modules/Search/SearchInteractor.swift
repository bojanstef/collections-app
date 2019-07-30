//
//  SearchInteractor.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol SearchInteractable {
    func loadPosts(after date: Date, result: @escaping ((Result<[Post], Error>) -> Void))
}

final class SearchInteractor {
    fileprivate let networkAccess: SearchAccessing

    init(networkAccess: SearchAccessing) {
        self.networkAccess = networkAccess
    }
}

extension SearchInteractor: SearchInteractable {
    func loadPosts(after date: Date, result: @escaping ((Result<[Post], Error>) -> Void)) {
        networkAccess.loadPosts(after: date, result: result)
    }
}
