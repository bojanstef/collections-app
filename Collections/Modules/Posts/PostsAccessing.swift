//
//  PostsAccessing.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol PostsAccessing {
    func loadPosts(after date: Date, result: @escaping ((Result<[Post], Error>) -> Void))
}
