//
//  ProductCard.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-05.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class ProductCard: ShadowCardCell, NibReusable {
    @IBOutlet fileprivate weak var productCountLabel: UILabel!
    @IBOutlet fileprivate weak var productDescriptionLabel: UILabel!
    @IBOutlet fileprivate weak var priceLabel: UILabel!
    @IBOutlet fileprivate weak var topDescriptionLabel: UILabel!
    @IBOutlet fileprivate weak var bottomDescriptionLabel: UILabel!

    func setup(with maxAccount: MaxAccount) {
        productCountLabel.text = "\(maxAccount.maxAccountType.intValue)"
        productDescriptionLabel.text = "Accounts"
        priceLabel.text = maxAccount.product.localizedPrice
        topDescriptionLabel.text = "Monthly"
        bottomDescriptionLabel.text = "I should update this."
    }
}
