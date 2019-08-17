//
//  Toolbar.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-16.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class Toolbar: UIToolbar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

fileprivate extension Toolbar {
    func setup() {
        tintColor = .lightGray
        items?.forEach { $0.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14)], for: .normal) }
    }
}
