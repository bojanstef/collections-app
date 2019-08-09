//
//  AccountsCell.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-19.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit
import CollectionsKit

private enum Constants {
    static let cellHeight: CGFloat = 44
}

final class AccountsCell: UITableViewCell, NibReusable {
    @IBOutlet fileprivate weak var usernameLabel: UILabel!
    static let cellHeight: CGFloat = Constants.cellHeight

    func setup(with account: Account) {
        usernameLabel.text = account.username
    }
}