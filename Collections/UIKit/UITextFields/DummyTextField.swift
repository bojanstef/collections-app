//
//  DummyTextField.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-28.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class DummyTextField: UITextField {
    override func layoutSubviews() {
        super.layoutSubviews()
        autocorrectionType = .no
        inputAssistantItem.leadingBarButtonGroups.removeAll()
        inputAssistantItem.trailingBarButtonGroups.removeAll()
    }
}
