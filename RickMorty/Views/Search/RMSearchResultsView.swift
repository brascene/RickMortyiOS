//
//  RMSearchResultsView.swift
//  RickMorty
//
//  Created by Dino Pelic on 22. 3. 2023..
//

import UIKit

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView)
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
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func processViewModel() {
        guard let viewModel = viewModel else { return }
        switch viewModel {
        case .characters(let characters):
            setupCollectionView()
        case .episodes(let episodes):
            setupCollectionView()
        case .locations(let locations):
            setupTableView()
        }
    }
    
    private func setupCollectionView() {
        
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .yellow
        tableView.isHidden = false
    }
    
    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }
}
