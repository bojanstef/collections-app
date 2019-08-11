//
//  ShadowCardCell.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

class ShadowCardCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        contentView.layer.masksToBounds = false
        layer.cornerRadius = 32
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
}
