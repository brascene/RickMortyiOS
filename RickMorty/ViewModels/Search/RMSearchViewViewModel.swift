//
//  RMSearchViewViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 4. 3. 2023..
//

import Foundation

final class RMSearchViewViewModel {
    let config: RMSearchViewController.Config
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var optionMapUpdateBlock:( ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    private var searchResultHandler: ((RMSearchResultViewModel) -> Void)?
    private var searchText: String = ""
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }
    
    public func executeSearch() {
        var queryParams: [URLQueryItem] = []
        
        if !searchText.isEmpty {
            queryParams.append(URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))
        }
        
        for (option, value) in optionMap {
            queryParams.append(URLQueryItem(name: option.queryArgument, value: value))
        }
        
        let request = RMRequest(endpoint: config.type.endpoint, queryParams: queryParams)
        
        switch config.type.endpoint {
        case .episode:
            makeSearchRequest(request, type: RMGetAllEpisodesResponse.self)
            break
        case .location:
            makeSearchRequest(request, type: RMGetAllEpisodesResponse.self)
            break
        case .character:
            makeSearchRequest(request, type: RMGetAllCharactersResponse.self)
            break
        }
    }
    
    private func handleSearchResult(model: Codable) {
        var resultsVM: RMSearchResultViewModel?
        if let episodesResponse = model as? RMGetAllEpisodesResponse {
            resultsVM = .episodes(episodesResponse.results.compactMap({ episode in
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataURL: URL(string: episode.url))
            }))
        }
        if let charactersResponse = model as? RMGetAllCharactersResponse {
            resultsVM = .characters(charactersResponse.results.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageUrl: URL(string: character.image))
            }))
        }
        if let locationsResponse = model as? RMGetAllLocationsResponse {
            resultsVM = .locations(locationsResponse.results.compactMap({ location in
                return RMLocationTableViewCellViewModel(location: location)
            }))
        }
        
        if let results = resultsVM {
            self.searchResultHandler?(results)
        }
    }
    
    private func makeSearchRequest<T: Codable>(_ request: RMRequest, type: T.Type) {
        RMService.shared.execute(request, expecting: type) { [weak self] result in
            switch result {
            case .success(let model):
                self?.handleSearchResult(model: model)
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
    
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption) {
        self.optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func registerOptionChangeBlock(_ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void) {
        self.optionMapUpdateBlock = block
    }
}

