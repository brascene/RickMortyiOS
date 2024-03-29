//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 6. 2. 2023..
//

import Foundation

final class RMCharacterCollectionViewCellViewModel: Hashable {
    public let characterName: String
    private let characterStatus: RMCharacterStatus
    private let characterImageUrl: URL?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageUrl)
    }
    
    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }

    init(characterName: String, characterStatus: RMCharacterStatus, characterImageUrl: URL?) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageManager.shared.downloadImage(url, completion: completion)
    }
}
