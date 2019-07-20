//
//  PostsInteractor.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

private enum Constants {
    static let dateFormat = "MMM dd @ HH:mm"
}

protocol PostsInteractable {
    func getTitleFromSearchedDate() -> String
    func loadPosts(result: @escaping ((Result<[Post], Error>) -> Void))
}

final class PostsInteractor {
    fileprivate let networkAccess: PostsAccessing
    fileprivate let searchedDate: Date

    init(networkAccess: PostsAccessing, searchedDate: Date) {
        self.networkAccess = networkAccess
        self.searchedDate = searchedDate
    }
}

extension PostsInteractor: PostsInteractable {
    func getTitleFromSearchedDate() -> String {
        // TODO: - Create a custom date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        return dateFormatter.string(from: searchedDate)
    }

    func loadPosts(result: @escaping ((Result<[Post], Error>) -> Void)) {
        networkAccess.loadPosts(after: searchedDate, result: result)
    }
}
