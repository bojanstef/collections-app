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
    fileprivate var userID: String? {
        guard let sharedContainer = UserDefaults(suiteName: UserDefaultSharedContainer.default) else { return nil }
        return sharedContainer.string(forKey: UserDefaultsKey.userID)
    }

    fileprivate let fireDB: Firestore

    init() {
        fireDB = Firestore.firestore()
        let settings = fireDB.settings
        settings.areTimestampsInSnapshotsEnabled = true
        fireDB.settings = settings
    }
}

extension NetworkGateway: SaveAccountAccessing {
    func getInstagramEmbedded(fromURL url: URL, result: @escaping ((Result<InstagramEmbedded, Error>) -> Void)) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                if let error = error { throw error }
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.isSuccessCode else { throw URLError(.badServerResponse) }
                guard let data = data else { throw NSError(domain: "No data", code: 0, userInfo: nil) }
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
            result(.failure(AuthError.noUser))
            return
        }

        fireDB.collection("users").document(userID).collection("accounts").whereField("username", isEqualTo: account.username)
            .getDocuments { [weak self] snapshots, error in
                do {
                    guard let this = self else { throw ReferenceError.type(self) }
                    if let error = error { throw error }
                    let accounts: [Account] = try snapshots!.documents.compactMap { snapshot -> Account in
                        let json = snapshot.data()
                        return try Account(json: json)
                    }

                    guard accounts.isEmpty else { throw AccountError.duplicate(accounts.first?.username) }
                    this.fireDB.collection("users").document(userID).collection("accounts")
                        .addDocument(data: (account.json as? [String: Any])!) { error in
                            if let error = error {
                                result(.failure(error))
                                return
                            }

                            result(.success(account))
                    }
                } catch {
                    result(.failure(error))
                }
            }
    }
}
