//
//  SearchPresenter.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

private enum Constants {
    static let dateFormat = "MMM dd @ HH:mm"
}

protocol SearchPresentable {
    func getTitleFromSearchedDate(_ searchedDate: Date) -> String
    func loadPosts(after date: Date, result: @escaping ((Result<[Post], Error>) -> Void))
    func navigateToPostDetail(_ selectedPost: Post)
    func scrapeAccounts(result: @escaping ((Result<Void, Error>) -> Void))
}

final class SearchPresenter {
    fileprivate weak var moduleDelegate: SearchModuleDelegate?
    fileprivate let interactor: SearchInteractable

    init(moduleDelegate: SearchModuleDelegate?, interactor: SearchInteractable) {
        self.moduleDelegate = moduleDelegate
        self.interactor = interactor
    }
}

extension SearchPresenter: SearchPresentable {
    func getTitleFromSearchedDate(_ searchedDate: Date) -> String {
        // TODO: - Create a custom date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        return dateFormatter.string(from: searchedDate)
    }

    func loadPosts(after date: Date, result: @escaping ((Result<[Post], Error>) -> Void)) {
        interactor.loadPosts(after: date, result: result)
    }

    func navigateToPostDetail(_ selectedPost: Post) {
        moduleDelegate?.navigateToPostDetail(selectedPost)
    }

    func scrapeAccounts(result: @escaping ((Result<Void, Error>) -> Void)) {
        interactor.scrapeAccounts(result: result)
    }
}
