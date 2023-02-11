//
//  RMEndpoint.swift
//  RickMorty
//
//  Created by Dino Pelic on 5. 2. 2023..
//

import Foundation

/// Represents unique API endpoint
@frozen enum RMEndpoint: String, Hashable, CaseIterable {
    case character
    case episode
    case location
}
