//
//  BarButtonItem.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-28.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class BarButtonItem: UIBarButtonItem {
    override init() {
        super.init()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

fileprivate extension BarButtonItem {
    func setup() {
        tintColor = .black
    }
}
