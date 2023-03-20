//
//  RMSearchResultViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 18. 3. 2023..
//

import Foundation

enum RMSearchResultViewModel {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
