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
        backgroundColor = .ultraviolet
        setTitleColor(.white, for: .normal)
        layer.masksToBounds = true
        layer.cornerRadius = 8
    }
}
