//
//  SearchPresenter.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol SearchPresentable {
    func searchAfterDate(_ searchedDate: Date)
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
    func searchAfterDate(_ searchedDate: Date) {
        moduleDelegate?.searchAfterDate(searchedDate)
    }

    func scrapeAccounts(result: @escaping ((Result<Void, Error>) -> Void)) {
        interactor.scrapeAccounts(result: result)
    }
}
