//
//  AccountsHeaderView.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-29.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol AccountsHeaderViewDelegate: AnyObject {
    func getPhotos()
}

final class AccountsHeaderView: UIView {
    weak var delegate: AccountsHeaderViewDelegate?
}

fileprivate extension AccountsHeaderView {
    @IBAction func getButtonPressed(_ sender: Any) {
        delegate?.getPhotos()
    }
}
