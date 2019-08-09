//
//  ProductCard.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-05.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import StoreKit
import UIKit

final class ProductCard: UICollectionViewCell, NibReusable {
    @IBOutlet fileprivate weak var testLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .blue
    }

    func setup(with product: SKProduct) {
        testLabel.text = product.localizedTitle
    }
}
