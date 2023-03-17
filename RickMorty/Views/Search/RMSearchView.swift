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
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noSearchResultView, searchInputView)
        addConstraints()
        
        searchInputView.configure(with: .init(type: viewModel.config.type))
        searchInputView.delegate = self
        
        viewModel.registerOptionChangeBlock { (tuple: (RMSearchInputViewViewModel.DynamicOption, String)) in
            print(String(describing: "Selected \(tuple)"))
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
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
            
            noSearchResultView.widthAnchor.constraint(equalToConstant: 150),
            noSearchResultView.heightAnchor.constraint(equalToConstant: 150),
            noSearchResultView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noSearchResultView.centerYAnchor.constraint(equalTo: centerYAnchor) 
        ])
    }
    
    public func presentKeyboard() {
        searchInputView.presentKeyboard()
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
}
