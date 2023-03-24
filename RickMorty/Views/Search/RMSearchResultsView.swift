//
//  RMSearchResultsView.swift
//  RickMorty
//
//  Created by Dino Pelic on 22. 3. 2023..
//

import UIKit

protocol RMSearchResultsViewDelegate: AnyObject {
    func rmSearchResultsView(_ view: RMSearchResultsView, didTapLocation atIndex: Int)
}

final class RMSearchResultsView: UIView {
    private var viewModel: RMSearchResultViewModel? {
        didSet {
            processViewModel()
        }
    }
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentiier)
        tv.isHidden = true
        return tv
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        cv.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        cv.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        cv.isHidden = true
        return cv
    }()
    
    public weak var delegate: RMSearchResultsViewDelegate?
    private var locationViewModels: [RMLocationTableViewCellViewModel] = []
    
    private var collectionViewCellViewModels: [any Hashable] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView, collectionView)
        configureTableview()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureTableview() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func processViewModel() {
        guard let viewModel = viewModel else { return }
        switch viewModel {
        case .characters(let characters):
            self.collectionViewCellViewModels = characters
            setupCollectionView()
        case .episodes(let episodes):
            self.collectionViewCellViewModels = episodes
            setupCollectionView()
        case .locations(let locations):
            setupTableView(viewModels: locations)
        }
    }
    
    private func setupCollectionView() {
        collectionView.isHidden = false
        tableView.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    private func setupTableView(viewModels: [RMLocationTableViewCellViewModel]) {
        collectionView.isHidden = true
        locationViewModels = viewModels
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }
}

extension RMSearchResultsView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentiier, for: indexPath) as? RMLocationTableViewCell else { fatalError("No location cell") }
        cell.configure(with: self.locationViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.rmSearchResultsView(self, didTapLocation: indexPath.row)
    }
}

extension RMSearchResultsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let object = collectionViewCellViewModels[indexPath.row]
        
        if let characterModel = object as? RMCharacterCollectionViewCellViewModel {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else { fatalError("") }
            cell.configure(with: characterModel)
            return cell
        }
        
        if let episodeModel = object as? RMCharacterEpisodeCollectionViewCellViewModel {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else { fatalError("") }
            cell.setup(with: episodeModel)
            return cell
        }
        
        fatalError("Cant dequeue cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        
        if currentViewModel is RMCharacterCollectionViewCellViewModel {
            let width = (bounds.width-30)/2
            return CGSize(width: width, height: width * 1.5)
        }
        
        if currentViewModel is RMCharacterEpisodeCollectionViewCellViewModel {
            let width = bounds.width-20
            return CGSize(width: width, height: 100)
        }
        
        return .zero
    }
}
