//
//  RMCharacterDetailViewController.swift
//  RickMorty
//
//  Created by Dino Pelic on 6. 2. 2023..
//

import UIKit

final class RMCharacterDetailViewController: UIViewController {
    private let viewModel: RMCharacterDetailsViewModel
    private let detailsView: RMCharacterDetailView
    
    init(viewModel: RMCharacterDetailsViewModel) {
        self.viewModel = viewModel
        self.detailsView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        view.addSubview(detailsView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        addConstraints()
        
        detailsView.collectionView?.delegate = self
        detailsView.collectionView?.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
    }
    
    @objc private func didTapShare() {
        
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .photo:
            return 1
        case .information(let viewModels):
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = viewModel.sections[indexPath.section]
        switch section {
        case .photo(let vm):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterPhotoCollectionViewCell else { return UICollectionViewCell() }
            cell.backgroundColor = .systemPink
            cell.setup(with: vm)
            return cell
        case .information(let vm):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterInfoCollectionViewCell else { return UICollectionViewCell() }
            cell.backgroundColor = .systemGreen
            cell.setup(with: vm[indexPath.row])
            return cell
        case .episodes(let vm):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else { return UICollectionViewCell() }
            cell.backgroundColor = .systemPurple
            cell.setup(with: vm)
            return cell
        }
    }
}
