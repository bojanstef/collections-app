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
    fileprivate let facebookAccess: FacebookAccessing
    fileprivate let photoAccess: PhotoAccessing

    init(facebookAccess: FacebookAccessing, photoAccess: PhotoAccessing) {
        self.photoAccess = photoAccess
        self.facebookAccess = facebookAccess
    }
}

extension SearchInteractor: SearchInteractable {
    func askPhotoPermissions() {
        photoAccess.askPhotoPermissions()
    }

    func loadPosts(after date: Date, result: @escaping ((Result<[Post], Error>) -> Void)) {
        let accounts = [Account(username: "bluebottle")]
        facebookAccess.loadPosts(for: accounts, after: date) { result in
            switch result {
            case .success(let posts):
                log.info(posts)
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        }
    }
}
