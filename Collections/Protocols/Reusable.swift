//
//  Reusable.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseId: String { get }
}

extension Reusable where Self: UICollectionViewCell {
    static var reuseId: String {
        return .init(describing: Self.self)
    }
}

extension Reusable where Self: UITableViewCell {
    static var reuseId: String {
        return .init(describing: Self.self)
    }
}

protocol NibReusable: Reusable {
    static var nib: UINib { get }
}

extension NibReusable where Self: UICollectionViewCell {
    static var nib: UINib {
        return .init(nibName: Self.reuseId, bundle: nil)
    }
}

extension NibReusable where Self: UITableViewCell {
    static var nib: UINib {
        return .init(nibName: Self.reuseId, bundle: nil)
    }
}
