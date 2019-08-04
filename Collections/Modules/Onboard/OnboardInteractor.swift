//
//  OnboardInteractor.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-02.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol OnboardInteractable {}

final class OnboardInteractor {
    fileprivate let networkAccess: OnboardAccessing

    init(networkAccess: OnboardAccessing) {
        self.networkAccess = networkAccess
    }
}

extension OnboardInteractor: OnboardInteractable {}
