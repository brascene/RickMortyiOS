//
//  RMSearchInputView.swift
//  RickMorty
//
//  Created by Dino Pelic on 4. 3. 2023..
//

import UIKit

final class RMSearchInputView: UIView {
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search "
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    private var viewModel: RMSearchInputViewViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else { return }
            let options = viewModel.options
            createOptionSelectionView(options: options)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemPink

        addSubviews(searchBar)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func createOptionSelectionView(options: [RMSearchInputViewViewModel.DynamicOption]) {
        for option in options {
            
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor, constant: 5),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor, constant: -5),
            searchBar.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    public func configure(with viewModel: RMSearchInputViewViewModel) {
        searchBar.placeholder = viewModel.searchPlaceholderText
        self.viewModel = viewModel
    }
}
