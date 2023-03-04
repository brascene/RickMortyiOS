//
//  RMLocationViewController.swift
//  RickMorty
//
//  Created by Dino Pelic on 5. 2. 2023..
//

import UIKit

final class RMLocationViewController: UIViewController {
    private let locationView = RMLocationView()
    private let viewModel = RMLocationViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(locationView)
        locationView.delegate = self
        view.backgroundColor = .systemBackground
        title = "Locations"
        addConstraints()
        viewModel.delegate = self
        viewModel.fetchLocations()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            locationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            locationView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            locationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension RMLocationViewController: RMLocationViewViewModelDelegate, RMLocationViewDelegate {
    func didFetchInitialLocations() {
        locationView.configure(with: viewModel)
    }
    
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
        let locationDetailsVC = RMLocationDetailsViewController(location: location)
        locationDetailsVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(locationDetailsVC, animated: true)
    }
}
