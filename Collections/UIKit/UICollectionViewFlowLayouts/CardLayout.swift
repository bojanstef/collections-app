//
//  CardLayout.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-05.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

private enum Constants {
    static let threeSevenths: CGFloat = 3 / 7
}

final class CardLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { fatalError(#function) }
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        let threeSeventhsWidth = collectionView.bounds.width * Constants.threeSevenths
        itemSize = CGSize(width: threeSeventhsWidth, height: collectionView.bounds.height)
        minimumInteritemSpacing = 8
        scrollDirection = .horizontal
    }
}
