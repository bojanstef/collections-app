//
//  NavigationTitleButton.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-28.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class NavigationTitleButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        tintColor = .black
        setTitleColor(.black, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        semanticContentAttribute = .forceRightToLeft // to place the icon on the right side

        guard let imageView = imageView else { return }
        imageView.contentMode = .scaleAspectFit
        imageView.bounds.size = CGSize(width: 16, height: 16)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
    }
}
