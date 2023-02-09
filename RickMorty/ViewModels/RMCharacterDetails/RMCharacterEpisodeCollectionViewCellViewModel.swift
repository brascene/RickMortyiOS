//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 9. 2. 2023..
//

import Foundation

final class RMCharacterEpisodeCollectionViewCellViewModel {
    private let episodeDataURL: URL?
    
    init(episodeDataURL: URL?) {
        self.episodeDataURL = episodeDataURL
    }
}
