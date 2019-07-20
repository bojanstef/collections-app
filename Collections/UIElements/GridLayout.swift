//
//  GridLayout.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

private enum Constants {
    static let oneThird: CGFloat = 1 / 3
}

final class GridLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { fatalError(#function) }
        let oneThirdWidth = collectionView.bounds.width * Constants.oneThird
        itemSize = CGSize(width: oneThirdWidth, height: oneThirdWidth)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }
}
