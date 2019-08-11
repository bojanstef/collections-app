//
//  Modellable.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-10.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol Modellable: Codable {
    static var jsonEncoder: JSONEncoder { get }
    var json: Any { get }

    static var jsonDecoder: JSONDecoder { get }
    init(json: Any) throws
}

extension Modellable {
    static var jsonEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }

    var json: Any {
        do {
            let data = try Self.jsonEncoder.encode(self)
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            fatalError("Error \(error), failed to serialize \(self)")
        }
    }

    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    init(json: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys])
        self = try Self.jsonDecoder.decode(Self.self, from: data)
    }
}
