//
//  RMCharacterStatus.swift
//  RickMorty
//
//  Created by Dino Pelic on 5. 2. 2023..
//

import Foundation

enum RMCharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case `unknown` = "unknown"
}
