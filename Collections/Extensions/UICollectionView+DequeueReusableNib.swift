//
//  UICollectionView+DequeueReusableNib.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: NibReusable>(_ type: T.Type = T.self, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseId, for: indexPath) as? T else {
            fatalError("Could not dequeue reusable cell of type \(type)")
        }

        return cell
    }
}
