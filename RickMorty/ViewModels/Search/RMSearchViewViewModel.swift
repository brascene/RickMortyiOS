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
    private var searchText: String = ""
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    public func executeSearch() {
        
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

