//
//  AccountsHeaderView.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-29.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol AccountsHeaderViewDelegate: AnyObject {
    func getPhotos(completion: @escaping (() -> Void))
}

final class AccountsHeaderView: UIView, NibLoadable {
    @IBOutlet fileprivate weak var getButton: ActionButton!
    fileprivate let activityView = UIActivityIndicatorView(style: .whiteLarge)
    weak var delegate: AccountsHeaderViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        activityView.hidesWhenStopped = true
        getButton.addSubview(activityView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        activityView.frame = getButton.bounds
    }
}

fileprivate extension AccountsHeaderView {
    @IBAction func getButtonPressed(_ sender: Any) {
        activityView.startAnimating()
        getButton.isUserInteractionEnabled = false

        delegate?.getPhotos { [weak self] in
            DispatchQueue.main.async {
                self?.activityView.stopAnimating()
                self?.getButton.isUserInteractionEnabled = true
            }
        }
    }
}