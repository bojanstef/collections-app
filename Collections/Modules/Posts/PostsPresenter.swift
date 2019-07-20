//
//  PostsPresenter.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol PostsPresentable {
    func getTitleFromSearchedDate() -> String
    func loadPosts(result: @escaping ((Result<[Post], Error>) -> Void))
}

final class PostsPresenter {
    fileprivate weak var moduleDelegate: PostsModuleDelegate?
    fileprivate let interactor: PostsInteractable

    init(moduleDelegate: PostsModuleDelegate?, interactor: PostsInteractable) {
        self.moduleDelegate = moduleDelegate
        self.interactor = interactor
    }
}

extension PostsPresenter: PostsPresentable {
    func getTitleFromSearchedDate() -> String {
        return interactor.getTitleFromSearchedDate()
    }

    func loadPosts(result: @escaping ((Result<[Post], Error>) -> Void)) {
        interactor.loadPosts(result: result)
    }
}
