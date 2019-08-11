//
//  MaxAccountsCard.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class MaxAccountsCard: ShadowCardCell, NibReusable {
    func setup(with maxAccount: MaxAccount) {
        log.info(maxAccount)
    }
}
