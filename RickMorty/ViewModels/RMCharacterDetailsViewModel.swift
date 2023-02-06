//
//  RMCharacterDetailsViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 6. 2. 2023..
//

import Foundation

final class RMCharacterDetailsViewModel {
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
