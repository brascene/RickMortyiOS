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
    
    private var didLoadMoreLocations: (() -> Void)?
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    public var isLoadingMoreLocations: Bool = false
    
    init() {
        
    }
    
    public func registerForDidLoadMoreLocations(_ block: @escaping () -> Void) {
        self.didLoadMoreLocations = block
    }
    
    public func location(for index: Int) -> RMLocation? {
        guard index < locations.count, index >= 0 else { return nil }
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
    
    public func fetchAdditionalLocations() {
        guard !isLoadingMoreLocations else {
            return
        }
        
        guard let nextUrlString = apiInfo?.next, let url = URL(string: nextUrlString), let request = RMRequest(url: url) else {
            isLoadingMoreLocations = false
            return
        }
        
        isLoadingMoreLocations = true
        
        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) {[weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let model):
                let moreResults = model.results
                strongSelf.apiInfo = model.info
                
                strongSelf.locations.append(contentsOf: moreResults)
                
                DispatchQueue.main.async {
                    strongSelf.didLoadMoreLocations?()
                    strongSelf.isLoadingMoreLocations = false
                }
            case .failure(let error):
                print(String(describing: error))
                strongSelf.isLoadingMoreLocations = false
            }
        }
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}
