//
//  RMLocationViewViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 2. 3. 2023..
//

import Foundation

final class RMLocationViewViewModel {
    private var locations: [RMLocation] = []
    private var cellViewModels: [String] = []
    
    init() {
        
    }
    
    public func fetchLocations() {
        RMService.shared.execute(RMRequest.listLocationsRequest, expecting: String.self) { result in
            switch result {
            case .success(let model):
                break
            case .failure(let failure):
                break
            }
        }
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}
