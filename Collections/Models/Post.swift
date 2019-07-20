//
//  Post.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

final class Post: Modellable { // Use class for pass-by-reference semantics to save `imageData`.
    let instagramId: String
    let ownerUsername: String
    let displayUrl: String
    let description: String?
    let timestamp: Int
    let taggedLocation: String?
    let taggedUsernames: [String]
    let followerCount: Int?
    private var imageData: Data?

    func saveImageData(_ data: Data) {
        imageData = data
    }

    func getImageData() -> Data? {
        return imageData
    }
}
