//
//  RMLocationDetailsViewController.swift
//  RickMorty
//
//  Created by Dino Pelic on 4. 3. 2023..
//

import UIKit


final class RMLocationDetailsViewController: UIViewController {
    private let viewModel: RMLocationDetailsViewViewModel
    private let detailView: RMLocationDetailsView = RMLocationDetailsView()
    private let location: RMLocation
    
    init(location: RMLocation) {
        let url = URL(string: location.url)
        self.viewModel = RMLocationDetailsViewViewModel(endpointUrl: url)
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = location.name
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        detailView.delegate = self
        setupConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didShare))
        
        viewModel.delegate = self
        viewModel.fetchLocationData()
    }
    
    @objc private func didShare() {
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension RMLocationDetailsViewController: RMLocationDetailsViewViewModelDelegate {
    func didFetchLocationDetails() {
        detailView.configure(with: viewModel)
    }
}

extension RMLocationDetailsViewController: RMLocationDetailsViewDelegate {
    func rmLocationDetailView(_ detailView: RMLocationDetailsView, didSelect character: RMCharacter) {
        let cvc = RMCharacterDetailViewController(viewModel: RMCharacterDetailsViewModel(character: character))
        cvc.navigationItem.largeTitleDisplayMode = .never
        cvc.title = character.name
        navigationController?.pushViewController(cvc, animated: true)
    }
}
