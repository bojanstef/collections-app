//
//  PhotoAlbum.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-24.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Photos

protocol PhotoAccessing {
    func askPhotoPermissions()
    func saveImage(_ image: UIImage, result: @escaping ((Result<Void, Error>) -> Void))
}

private enum Constants {
    static let albumName = "Collections.app"
}

final class PhotoAlbum {
    fileprivate var assetCollection: PHAssetCollection?
    fileprivate static var assetCollectionForAlbum: PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", Constants.albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        return collection.firstObject
    }

    static let sharedInstance = PhotoAlbum()
    private init() {}
}

extension PhotoAlbum: PhotoAccessing {
    func askPhotoPermissions() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            break // TODO: - .success (do nothing)
        case .denied:
            break // TODO: - .failed (show user how to update Settings.app)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                log.info(status)
            }
        case .restricted:
            break
        @unknown default:
            log.error("Unknown or new authorization status \(status)")
        }
    }

    func saveImage(_ image: UIImage, result: @escaping ((Result<Void, Error>) -> Void)) {
        func getAlbum(result: @escaping ((Result<PHAssetCollection, Error>) -> Void)) {
            if let assetCollection = PhotoAlbum.assetCollectionForAlbum {
                result(.success(assetCollection))
            } else {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: Constants.albumName)
                }, completionHandler: { success, error in
                    do {
                        if let error = error { throw error }
                        guard success else { throw PhotoError.creationFailure }
                        guard let assetCollection = PhotoAlbum.assetCollectionForAlbum else { throw PhotoError.creationFailure }
                        result(.success(assetCollection))
                    } catch {
                        result(.failure(error))
                    }
                })
            }
        }

        getAlbum { [weak self] albumResult in
            switch albumResult {
            case .success(let assetCollection):
                self?.performSaveImageRequest(image, assetCollection: assetCollection, result: result)
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
}

fileprivate extension PhotoAlbum {
    func performSaveImageRequest(_ image: UIImage, assetCollection: PHAssetCollection, result: @escaping ((Result<Void, Error>) -> Void)) {
        PHPhotoLibrary.shared().performChanges({
            do {
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                guard let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset else { throw AssetError.noPlaceholder }
                guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection) else { throw AssetError.noCollectionChangeRequest }
                let fastEnumeration = NSArray(array: [assetPlaceholder])
                albumChangeRequest.addAssets(fastEnumeration)
                result(.success)
            } catch {
                result(.failure(error))
            }
        }, completionHandler: nil)
    }
}
