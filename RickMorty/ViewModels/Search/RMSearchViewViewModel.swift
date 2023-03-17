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
    private var searchResultHandler: (() -> Void)?
    private var searchText: String = ""
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    public func registerSearchResultHandler(_ block: @escaping () -> Void) {
        self.searchResultHandler = block
    }
    
    public func executeSearch() {
        searchText = "Rick"
        var queryParams: [URLQueryItem] = []
        
        if !searchText.isEmpty {
            queryParams.append(URLQueryItem(name: "name", value: searchText))
        }
        
        for (option, value) in optionMap {
            queryParams.append(URLQueryItem(name: option.queryArgument, value: value))
        }
        
        let request = RMRequest(endpoint: config.type.endpoint)
        RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { result in
            switch result {
            case .success(let success):
                print("Search result: \(success.results.count)")
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

