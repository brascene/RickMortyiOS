//
//  RMEpisodeListViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 11. 2. 2023..
//

import Foundation
import UIKit

protocol RMEpisodeListViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
    func didSelectEpisode(_ episode: RMEpisode)
}

final class RMEpisodeListViewModel: NSObject {
    private var episodes: [RMEpisode] = [] {
        didSet {
            for episode in episodes {
                let vm = RMCharacterEpisodeCollectionViewCellViewModel(episodeDataURL: URL(string: episode.url), borderColor: borderColor.randomElement() ?? .systemBlue)
                if !cellViewModels.contains(vm) {
                    cellViewModels.append(vm)
                }
            }
        }
    }
    private var cellViewModels: [RMCharacterEpisodeCollectionViewCellViewModel] = []
    private var apiInfo: RMGetAllEpisodesResponse.Info? = nil
    public weak var delegate: RMEpisodeListViewModelDelegate?
    
    private var isLoadingMoreEpisodes = false
    private let borderColor: [UIColor] = [
        .systemBlue,
        .systemGreen,
        .systemOrange,
        .systemPink,
        .systemPurple,
        .systemRed,
        .yellow,
        .systemMint,
        .systemIndigo
    ]
    public var shouldShowMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    // MARK: Functinons
    public func fetchEpisodes() {
        RMService.shared.execute(.episodeListRequest, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.episodes = model.results
                self?.apiInfo = model.info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                }
                break
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    public func fetchAdditionalEpisodes(url: URL) {
        guard !isLoadingMoreEpisodes else {
            return
        }
        isLoadingMoreEpisodes = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreEpisodes = false
            return
        }
        
        RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) {[weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let model):
                let moreResults = model.results
                strongSelf.apiInfo = model.info
                
                let previousCount = strongSelf.episodes.count
                strongSelf.episodes.append(contentsOf: moreResults)
                
                let indexPathsToAdd: [IndexPath] = Array(previousCount..<(previousCount + moreResults.count)).compactMap { return IndexPath(row: $0, section: 0) }
                                                
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreEpisodes(with: indexPathsToAdd)
                    strongSelf.isLoadingMoreEpisodes = false
                }
            case .failure(let error):
                print(String(describing: error))
                strongSelf.isLoadingMoreEpisodes = false
            }
        }
    }
}

extension RMEpisodeListViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        cell.setup(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
            fatalError("Unsupported")
        }
        
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier, for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
                
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension RMEpisodeListViewModel: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let size = bounds.width - 20
        return CGSize(width: size, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(episode)
    }
}

extension RMEpisodeListViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowMoreIndicator,
              !isLoadingMoreEpisodes,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {[weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset > 0 && offset >= totalContentHeight - totalScrollViewFixedHeight - 120 {
                self?.fetchAdditionalEpisodes(url: url)
            }
            t.invalidate()
        }
    }
}
