//
//  SearchInteractor.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol SearchInteractable {}

final class SearchInteractor {
    fileprivate let networkAccess: SearchAccessing

    init(networkAccess: SearchAccessing) {
        self.networkAccess = networkAccess
    }
}

extension SearchInteractor: SearchInteractable {}
