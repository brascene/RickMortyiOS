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
    
    public weak var delegate: RMSearchResultsViewDelegate?
    private var locationViewModels: [RMLocationTableViewCellViewModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView)
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
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
            setupCollectionView()
        case .episodes(let episodes):
            setupCollectionView()
        case .locations(let locations):
            setupTableView(viewModels: locations)
        }
    }
    
    private func setupCollectionView() {
        
    }
    
    private func setupTableView(viewModels: [RMLocationTableViewCellViewModel]) {
        self.locationViewModels = viewModels
        tableView.backgroundColor = .yellow
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
