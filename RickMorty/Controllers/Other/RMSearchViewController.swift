//
//  RMSearchViewController.swift
//  RickMorty
//
//  Created by Dino Pelic on 12. 2. 2023..
//

import UIKit

final class RMSearchViewController: UIViewController {
    struct Config {
        enum `Type` {
            case character
            case episode
            case location
            
            var title: String {
                switch self {
                case .character:
                    return "Search character"
                case .episode:
                    return "Search episode"
                case .location:
                    return "Search location"
                }
            }
        }
        
        let type: `Type`
    }
        
    private let searchView: RMSearchView
    private let viewModel: RMSearchViewViewModel
    
    init(config: Config) {
        let vm = RMSearchViewViewModel(config: config)
        self.viewModel = vm
        self.searchView = RMSearchView(frame: .zero, viewModel: vm)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
        view.addSubview(searchView)
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(didTap))
    }
    
    @objc private func didTap() {
        viewModel.executeSearch()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
