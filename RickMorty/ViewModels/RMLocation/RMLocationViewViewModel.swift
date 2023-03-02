//
//  RMLocationViewViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 2. 3. 2023..
//

import Foundation

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewViewModel {
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cm = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cm) {
                    cellViewModels.append(cm)
                }
            }
        }
    }
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    
    private var apiInfo: RMGetAllLocationsResponse.Info?
    weak var delegate: RMLocationViewViewModelDelegate?
    
    init() {
        
    }
    
    public func location(for index: Int) -> RMLocation? {
        guard index < locations.count else { return nil }
        return locations[index]
    }
    
    public func fetchLocations() {
        RMService.shared.execute(RMRequest.listLocationsRequest, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let failure):
                print(String(describing: failure))
                break
            }
        }
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}
