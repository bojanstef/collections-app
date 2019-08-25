//
//  SearchInteractor.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol SearchInteractable {
    func askPhotoPermissions()
    func loadPosts(after date: Date, result: @escaping ((Result<[Post], Error>) -> Void))
}

final class SearchInteractor {
    fileprivate let networkAccess: SearchAccessing
    fileprivate let photoAccess: PhotoAccessing

    init(networkAccess: SearchAccessing, photoAccess: PhotoAccessing) {
        self.networkAccess = networkAccess
        self.photoAccess = photoAccess
    }
}

extension SearchInteractor: SearchInteractable {
    func askPhotoPermissions() {
        photoAccess.askPhotoPermissions()
    }

    func loadPosts(after date: Date, result: @escaping ((Result<[Post], Error>) -> Void)) {
        networkAccess.loadPosts(after: date, result: result)
    }
}
