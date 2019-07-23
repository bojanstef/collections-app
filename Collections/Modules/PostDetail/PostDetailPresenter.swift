//
//  PostDetailPresenter.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-22.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol PostDetailPresentable {
    var post: Post { get }
}

final class PostDetailPresenter {
    fileprivate weak var moduleDelegate: PostDetailModuleDelegate?
    fileprivate let interactor: PostDetailInteractable

    init(moduleDelegate: PostDetailModuleDelegate?, interactor: PostDetailInteractable) {
        self.moduleDelegate = moduleDelegate
        self.interactor = interactor
    }
}

extension PostDetailPresenter: PostDetailPresentable {
    var post: Post {
        return interactor.post
    }
}
