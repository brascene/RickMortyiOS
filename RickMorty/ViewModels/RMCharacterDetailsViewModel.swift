//
//  RMCharacterDetailsViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 6. 2. 2023..
//

import Foundation

final class RMCharacterDetailsViewModel {
    private let character: RMCharacter
    
    enum SectionTypes: CaseIterable {
        case photo
        case information
        case episodes
    }
    
    public let sections = SectionTypes.allCases
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
    
    private var requestUrl: URL? {
        return URL(string: character.url)
    }
}
