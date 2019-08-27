//
//  FacebookAccess.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-25.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit

private enum Constants {
    static let igPermissions = ["instagram_basic", "pages_show_list"]
}

protocol FacebookAccessing {
    func connectToInstagram(result: @escaping ((Result<IGAccountMetadata, Error>) -> Void))
    func instagramLogout(completion: @escaping (() -> Void))
}

final class FacebookAccess {
    static let shared: FacebookAccessing = FacebookAccess()
    private init() {}
}

extension FacebookAccess: FacebookAccessing {
    func connectToInstagram(result: @escaping ((Result<IGAccountMetadata, Error>) -> Void)) {
        LoginManager().logIn(permissions: Constants.igPermissions, from: nil) { [weak self] loginResult, error in
            do {
                if let error = error { throw error }
                guard let loginResult = loginResult else { throw NSError(domain: "No login result") }
                guard !loginResult.isCancelled else { throw NSError(domain: "Cancelled login") }
                self?.getBusinessAccounts(result: result)
            } catch {
                result(.failure(error))
            }
        }
    }

    func instagramLogout(completion: @escaping (() -> Void)) {
        LoginManager().logOut()
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.igAccountMetadataJSON)
        completion()
    }
}

fileprivate extension FacebookAccess {
    func getBusinessAccounts(result: @escaping ((Result<IGAccountMetadata, Error>) -> Void)) {
        do {
            guard let tokenString = AccessToken.current?.tokenString else { throw NSError(domain: "No access token") }
            let request = GraphRequest(graphPath: "me/accounts", parameters: ["fields": ""], tokenString: tokenString, version: nil, httpMethod: .get)
            request.start { [weak self] _, json, error in
                do {
                    if let error = error { throw error }
                    guard let json = json else { throw NSError(domain: "No JSON response") }
                    let container = try DataContainer<IGAccount>(json: json)
                    guard let instagramId = container.data.first?.id else { throw NSError(domain: "No Instagram ID") }
                    self?.getBusinessAccountId(from: instagramId, result: result)
                } catch {
                    result(.failure(error))
                }
            }
        } catch {
            result(.failure(error))
        }
    }

    func getBusinessAccountId(from instagramId: String, result: @escaping ((Result<IGAccountMetadata, Error>) -> Void)) {
        do {
            guard let tokenString = AccessToken.current?.tokenString else { throw NSError(domain: "No access token") }
            let params: [String: Any] = ["fields": "instagram_business_account"]
            let request = GraphRequest(graphPath: instagramId, parameters: params, tokenString: tokenString, version: nil, httpMethod: .get)
            request.start { [weak self] _, json, error in
                do {
                    if let error = error { throw error }
                    guard let json = json else { throw NSError(domain: "No JSON response") }
                    let igAccountContainer = try IGAccountContainer(json: json)
                    let requesterId = igAccountContainer.instagramBusinessAccount.id
                    self?.getInstagramMetadata(from: requesterId, result: result)
                } catch {
                    result(.failure(error))
                }
            }
        } catch {
            result(.failure(error))
        }
    }

    func getInstagramMetadata(from instagramId: String, result: @escaping ((Result<IGAccountMetadata, Error>) -> Void)) {
        do {
            guard let tokenString = AccessToken.current?.tokenString else { throw NSError(domain: "No access token") }
            let params: [String: Any] = ["fields": "username,profile_picture_url"]
            let request = GraphRequest(graphPath: instagramId, parameters: params, tokenString: tokenString, version: nil, httpMethod: .get)
            request.start { _, json, error in
                do {
                    if let error = error { throw error }
                    guard let json = json else { throw NSError(domain: "No JSON response") }
                    let metadata = try IGAccountMetadata(json: json)
                    UserDefaults.standard.set(metadata.json, forKey: UserDefaultsKey.igAccountMetadataJSON) // TODO: Cleanup. Use better caching. I don't know.
                    result(.success(metadata))
                } catch {
                    result(.failure(error))
                }
            }
        } catch {
            result(.failure(error))
        }
    }

    //self?.getMedia(from: "bluebottle", requesterId: requesterId, result: result)
    func getMedia(from businessAccount: String, requesterId: String, result: @escaping ((Result<Void, Error>) -> Void)) {
        //17841405309211844?fields={followers_count,media_count}&access_token={access-token}"
        do {
            guard let tokenString = AccessToken.current?.tokenString else { throw NSError(domain: "No access token") }
            let mediaQuery = "media{comments_count,like_count,timestamp}"
            let params: [String: Any] = ["fields": "business_discovery.username(\(businessAccount)){followers_count,media_count,\(mediaQuery)}"]
            let request = GraphRequest(graphPath: requesterId, parameters: params, tokenString: tokenString, version: nil, httpMethod: .get)
            request.start { _, json, error in
                do {
                    if let error = error { throw error }
                    guard let json = json else { throw NSError(domain: "No JSON response") }
                    result(.success)
                } catch {
                    result(.failure(error))
                }
            }
        } catch {
            result(.failure(error))
        }
    }
}
