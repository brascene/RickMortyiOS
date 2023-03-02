//
//  RMLocationTableViewCellViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 2. 3. 2023..
//

import Foundation

final class RMLocationTableViewCellViewModel: Hashable, Equatable {
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        return lhs.location.id == rhs.location.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(dimension)
        hasher.combine(location.id)
    }
    
    private let location: RMLocation
    
    init(location: RMLocation) {
        self.location = location
    }
    
    public var name: String {
        return location.name
    }
    
    public var type: String {
        return "Type " + location.type
    }
    
    public var dimension: String {
        return location.dimension
    }
}
