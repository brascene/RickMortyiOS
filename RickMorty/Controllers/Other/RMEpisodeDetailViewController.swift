//
//  RMEpisodeDetailViewController.swift
//  RickMorty
//
//  Created by Dino Pelic on 11. 2. 2023..
//

import UIKit

final class RMEpisodeDetailViewController: UIViewController {
    private let viewModel: RMEpisodeDetailViewViewModel
    private let detailView: RMEpisodeDetailView = RMEpisodeDetailView()
    
    init(url: URL?) {
        self.viewModel = RMEpisodeDetailViewViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        detailView.delegate = self
        setupConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didShare))
        
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
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

extension RMEpisodeDetailViewController: RMEpisodeDetailViewViewModelDelegate {
    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
    }
}

extension RMEpisodeDetailViewController: RMEpisodeDetailViewDelegate {
    func rmEpisodeDetailView(_ detailView: RMEpisodeDetailView, didSelect chracter: RMCharacter) {
        let cvc = RMCharacterDetailViewController(viewModel: RMCharacterDetailsViewModel(character: chracter))
        cvc.navigationItem.largeTitleDisplayMode = .never
        cvc.title = chracter.name
        navigationController?.pushViewController(cvc, animated: true)
    }
}
