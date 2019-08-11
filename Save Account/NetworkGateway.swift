//
//  NetworkGateway.swift
//  Save Account
//
//  Created by Bojan Stefanovic on 2019-07-25.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation
import FirebaseFirestore

private let log = Logger(category: "Network")

final class NetworkGateway {
    private var userID: String? {
        guard let sharedContainer = UserDefaults(suiteName: "group.xyz.bojan.Collections") else { return nil }
        return sharedContainer.string(forKey: "userID")
    }
}

extension NetworkGateway: SaveAccountAccessing {
    func getInstagramEmbedded(fromURL url: URL, result: @escaping ((Result<InstagramEmbedded, Error>) -> Void)) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { result(.failure(error!)); return }

            guard let httpResponse = response as? HTTPURLResponse else {
                // TODO: - Add custom error.
                result(.failure(NSError(domain: "Response is not a HTTPURLResponse", code: 0, userInfo: nil)))
                return
            }

            guard 200...299 ~= httpResponse.statusCode else {
                // TODO: - Add custom error.
                result(.failure(NSError(domain: "Error status code \(httpResponse.statusCode)", code: 0, userInfo: nil)))
                return
            }

            log.info(response.debugDescription)

            guard let data = data else {
                result(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                let instagramEmbedded = try InstagramEmbedded(json: json)
                result(.success(instagramEmbedded))
            } catch {
                result(.failure(error))
            }
        }

        task.resume()
    }

    func addAccount(_ account: Account, result: @escaping ((Result<Account, Error>) -> Void)) {
        guard let userID = userID else {
            // TODO: - Add custom error OR create a better user management system.
            result(.failure(NSError(domain: "No User ID", code: 0, userInfo: nil)))
            return
        }

        Firestore.firestore()
            .collection("users")
            .document(userID)
            .collection("accounts")
            .whereField("username", isEqualTo: account.username)
            .getDocuments { snapshots, error in
                guard error == nil else { result(.failure(error!)); return }
                do {
                    let accounts: [Account] = try snapshots!.documents.compactMap { snapshot -> Account in
                        let json = snapshot.data()
                        return try Account(json: json)
                    }

                    guard accounts.isEmpty else {
                        // TODO: - Read a custom error and present it to the user.
                        throw NSError(domain: "This username already exists", code: 0, userInfo: nil)
                    }

                    Firestore.firestore()
                        .collection("users")
                        .document(userID)
                        .collection("accounts")
                        .addDocument(data: (account.json as? [String: Any])!) { error in
                            guard let error = error else {
                                result(.success(account))
                                return
                            }

                            result(.failure(error))
                    }
                } catch {
                    result(.failure(error))
                }
            }
    }
}
