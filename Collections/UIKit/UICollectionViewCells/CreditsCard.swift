//
//  CreditsCard.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-05.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class CreditsCard: UICollectionViewCell, NibReusable {
    @IBOutlet fileprivate weak var testLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .blue
    }

    func setup(with string: String) {
        testLabel.text = string
    }
}
