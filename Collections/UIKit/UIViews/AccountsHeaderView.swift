//
//  AccountsHeaderView.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-29.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol AccountsHeaderViewDelegate: AnyObject {
    func instagramLogin(completion: @escaping (() -> Void))
}

final class AccountsHeaderView: UIView, NibLoadable {
    @IBOutlet fileprivate weak var creditsCountButton: UIButton!
    @IBOutlet fileprivate weak var followingButton: UIButton!
    @IBOutlet fileprivate weak var maxButton: UIButton!
    @IBOutlet fileprivate weak var connectInstagramButton: ActionButton!
    fileprivate let activityView = UIActivityIndicatorView(style: .whiteLarge)
    weak var delegate: AccountsHeaderViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        activityView.hidesWhenStopped = true
        connectInstagramButton.addSubview(activityView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        activityView.frame = connectInstagramButton.bounds
    }

    func setCreditsCount(_ newValue: Int) {
        creditsCountButton.setTitle(String(newValue), for: .normal)
    }

    func setFollowingCount(_ newValue: Int) {
        followingButton.setTitle(String(newValue), for: .normal)
    }

    func setMaxCount(_ newValue: Int) {
        maxButton.setTitle(String(newValue), for: .normal)
    }
}

fileprivate extension AccountsHeaderView {
    @IBAction func connectButtonPressed(_ sender: Any) {
        activityView.startAnimating()
        connectInstagramButton.isUserInteractionEnabled = false

        delegate?.instagramLogin { [weak self] in
            DispatchQueue.main.async {
                self?.activityView.stopAnimating()
                self?.connectInstagramButton.isUserInteractionEnabled = true
            }
        }
    }
}
