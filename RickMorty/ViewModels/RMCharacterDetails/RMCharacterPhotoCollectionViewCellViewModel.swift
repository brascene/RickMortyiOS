//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 9. 2. 2023..
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel {
    private let imageURL: URL?
    
    init(imageURL: URL?) {
        self.imageURL = imageURL
    }
    
    public func setupImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageURL = imageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageManager.shared.downloadImage(imageURL, completion: completion)
    }
}
