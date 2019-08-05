//
//  ActionButton.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-03.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class ActionButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    fileprivate func setup() {
        backgroundColor = UIColor(red: 80/255, green: 80/255, blue: 1, alpha: 1)
        setTitleColor(.white, for: .normal)
        layer.masksToBounds = true
        layer.cornerRadius = 8
    }
}
