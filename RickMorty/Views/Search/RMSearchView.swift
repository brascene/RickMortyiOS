//
//  RMSearchView.swift
//  RickMorty
//
//  Created by Dino Pelic on 4. 3. 2023..
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(_ inputView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
}

final class RMSearchView: UIView {
    private let viewModel: RMSearchViewViewModel
    weak var delegate: RMSearchViewDelegate?
    
    private let noSearchResultView = RMSearchNoResultView()
    private let searchInputView = RMSearchInputView()
    private let resultsView = RMSearchResultsView()
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(resultsView, noSearchResultView, searchInputView)
        addConstraints()
        
        searchInputView.configure(with: .init(type: viewModel.config.type))
        searchInputView.delegate = self
        
        setupHandlers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: 110),
            
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            resultsView.leftAnchor.constraint(equalTo: leftAnchor),
            resultsView.rightAnchor.constraint(equalTo: rightAnchor),
            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            
            noSearchResultView.widthAnchor.constraint(equalToConstant: 150),
            noSearchResultView.heightAnchor.constraint(equalToConstant: 150),
            noSearchResultView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noSearchResultView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    public func presentKeyboard() {
        searchInputView.presentKeyboard()
    }
    
    private func setupHandlers() {
        viewModel.registerOptionChangeBlock { (tuple: (RMSearchInputViewViewModel.DynamicOption, String)) in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        
        viewModel.registerSearchResultHandler { [weak self] results in
            DispatchQueue.main.async {
                self?.resultsView.configure(with: results)
                self?.noSearchResultView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }
        
        viewModel.registerNoSearchResultHandler {  [weak self] in
            DispatchQueue.main.async {
                self?.noSearchResultView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
    }
}

extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension RMSearchView: RMSearchInputViewDelegate {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }
    
    func rmSearchInputViewDidTapSearchKeyboard(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
}
