//
//  AccountsCell.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-19.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

private enum Constants {
    static let cellHeight: CGFloat = 64
}

final class AccountsCell: UITableViewCell, NibReusable {
    @IBOutlet fileprivate weak var usernameLabel: UILabel!
    static let cellHeight: CGFloat = Constants.cellHeight

    func setup(with account: Account) {
        usernameLabel.text = account.username
    }
}
