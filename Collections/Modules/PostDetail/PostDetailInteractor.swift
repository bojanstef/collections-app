//
//  PostDetailInteractor.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-22.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol PostDetailInteractable {
    var post: Post { get }
}

final class PostDetailInteractor {
    fileprivate let networkAccess: PostDetailAccessing
    fileprivate let selectedPost: Post

    init(networkAccess: PostDetailAccessing, selectedPost: Post) {
        self.networkAccess = networkAccess
        self.selectedPost = selectedPost
    }
}

extension PostDetailInteractor: PostDetailInteractable {
    var post: Post {
        return selectedPost
    }
}
