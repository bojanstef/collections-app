//
//  Post.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation
import UIKit

final class Post: Modellable { // Use class for pass-by-reference semantics to save `imageData`.
    let instagramId: String
    let ownerUsername: String
    let displayUrl: String
    let description: String?
    let timestamp: Int
    let taggedLocation: String?
    let taggedUsernames: [String]
    let followerCount: Int?
    private var image: UIImage?

    enum CodingKeys: String, CodingKey {
        case instagramId
        case ownerUsername
        case displayUrl
        case description
        case timestamp
        case taggedLocation
        case taggedUsernames
        case followerCount
    }
}

extension Post {
    func saveImage(_ image: UIImage) {
        self.image = image
    }

    func getImage() -> UIImage? {
        return image
    }
}
