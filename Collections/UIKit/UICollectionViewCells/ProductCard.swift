//
//  ProductCard.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-05.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class ProductCard: UICollectionViewCell, NibReusable {
    @IBOutlet fileprivate weak var creditCountLabel: UILabel!
    @IBOutlet fileprivate weak var priceLabel: UILabel!
    @IBOutlet fileprivate weak var percentSavingsLabel: UILabel!
    @IBOutlet fileprivate weak var extraCreditsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 32
        layer.borderWidth = 2
        layer.borderColor = UIColor.lightGray.cgColor
    }

    func setup(with credit: Credit) {
        creditCountLabel.text = "\(credit.creditType.intValue)"
        priceLabel.text = credit.product.localizedPrice
        percentSavingsLabel.text = "You save \(credit.creditType.percentSavings)%"
        extraCreditsLabel.text = "and get \(credit.creditType.extraCredits) extra credits"
    }
}
