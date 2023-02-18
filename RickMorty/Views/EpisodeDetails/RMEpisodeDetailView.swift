//
//  RMEpisodeDetailView.swift
//  RickMorty
//
//  Created by Dino Pelic on 11. 2. 2023..
//

import UIKit

final class RMEpisodeDetailView: UIView {
    private var viewModel: RMEpisodeDetailViewViewModel? {
        didSet {
            spinner.stopAnimating()
            self.collectionView?.reloadData()
            self.collectionView?.isHidden = false
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.collectionView?.alpha = 1
            }
        }
    }
    private var collectionView: UICollectionView?
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubviews(collectionView, spinner)
        addConstraints()
        
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        guard let collectionView = collectionView else { return }
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func configure(with viewModel: RMEpisodeDetailViewViewModel) {
        self.viewModel = viewModel
    }
}

extension RMEpisodeDetailView {
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { index, _ in
            return self.layout(for: index)
        })
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isHidden = true
        cv.alpha = 0
        cv.delegate = self
        cv.dataSource = self
        cv.register(RMEpisodeInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier)
        cv.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        return cv
    }
    
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        guard let sections = viewModel?.cellViewModels else {
            return getInfoLayout()
        }
        switch sections[section] {
        case .information:
            return getInfoLayout()
        case .characters:
            return getCharactersLayout()
        }
    }
    
    private func getCharactersLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(260)), subitems: [item, item])
        
        let section =  NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func getInfoLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), subitems: [item])
        let section =  NSCollectionLayoutSection(group: group)
        return section
    }
}

extension RMEpisodeDetailView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let cellViewModels = viewModel?.cellViewModels else { return 0 }
        switch cellViewModels[section] {
        case .information(let infos):
            return infos.count
        case .characters(let chars):
            return chars.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellViewModels = viewModel?.cellViewModels else { fatalError("No cell") }
        let sectionType = cellViewModels[indexPath.section]
        switch sectionType {
        case .information(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier, for: indexPath) as? RMEpisodeInfoCollectionViewCell else {
                fatalError("No cell")
            }
            cell.configure(with: viewModel[indexPath.row])
            return cell
        case .characters(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
                fatalError("No cell")
            }
            cell.configure(with: viewModel[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
