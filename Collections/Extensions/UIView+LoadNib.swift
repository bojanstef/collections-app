//
//  UIView+LoadNib.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-29.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

extension UIView {
    static func fromNib() -> Self {
        return loadNib(self)
    }

    private static func loadNib<T: UIView>(_ type: T.Type) -> T {
        let nibName = String(describing: self)
        guard let view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? T else {
            fatalError("Could not load nib named \(nibName)")
        }

        return view
    }
}
