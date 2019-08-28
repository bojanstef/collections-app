//
//  IGPost.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-26.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

struct IGMedia: Modellable {
    let id: String
    let businessDiscovery: IGPost
}

struct Media: Modellable {
    
}

struct IGPost: Modellable {
    let caption: String?
    let children: [IGPost]?
    let id: String
    let likeCount: Int
    let mediaType: String
    let mediaUrl: URL
    let permalink: URL
    let timestamp: Int
    let username: String
}
