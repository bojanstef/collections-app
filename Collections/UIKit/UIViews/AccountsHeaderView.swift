//
//  AccountsHeaderView.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-29.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol AccountsHeaderViewDelegate: AnyObject {
    func instagramLogout(completion: @escaping (() -> Void))
    func instagramLogin(completion: @escaping ((IGAccountMetadata?) -> Void))
}

final class AccountsHeaderView: UIView, NibLoadable {
    @IBOutlet fileprivate weak var accountProfileImageView: UIImageView!
    @IBOutlet fileprivate weak var followingButton: UIButton!
    @IBOutlet fileprivate weak var maxButton: UIButton!
    @IBOutlet fileprivate weak var connectInstagramButton: ActionButton!
    fileprivate var isIgConnected = false
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

    func setFollowingCount(_ newValue: Int) {
        followingButton.setTitle(String(newValue), for: .normal)
    }

    func setMaxCount(_ newValue: Int) {
        maxButton.setTitle(String(newValue), for: .normal)
    }

    func setup(with igAccountMetadata: IGAccountMetadata) {
        DispatchQueue.main.async { [weak self] in
            self?.isIgConnected = true
            self?.connectInstagramButton.setTitle("Disconnect \(igAccountMetadata.username)", for: .normal)
        }
    }

    func setupWithoutIG() {
        DispatchQueue.main.async { [weak self] in
            self?.isIgConnected = false
            self?.connectInstagramButton.setTitle("Connect your Instagram", for: .normal)
        }
    }
}

fileprivate extension AccountsHeaderView {
    func enableInteractivity() {
        DispatchQueue.main.async { [weak self] in
            self?.activityView.stopAnimating()
            self?.connectInstagramButton.isUserInteractionEnabled = true
        }
    }

    @IBAction func connectButtonPressed(_ sender: Any) {
        activityView.startAnimating()
        connectInstagramButton.isUserInteractionEnabled = false

        if isIgConnected {
            delegate?.instagramLogout { [weak self] in
                self?.enableInteractivity()
                self?.setupWithoutIG()
            }
        } else {
            delegate?.instagramLogin { [weak self] igAccountMetadata in
                self?.enableInteractivity()
                if let igAccountMetadata = igAccountMetadata {
                    self?.setup(with: igAccountMetadata)
                }
            }
        }
    }
}
