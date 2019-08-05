//
//  NibLoadable.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-04.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol NibLoadable {
    static func nib<T: UIView>(_ type: T.Type) -> Self
}

extension NibLoadable {
    static func nib<T: UIView>(_ type: T.Type = T.self) -> Self {
        let nibName = String(describing: self)
        guard let view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? Self else {
            fatalError("Could not load nib of type \(type)")
        }

        return view
    }
}
