//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 9. 2. 2023..
//

import Foundation

protocol RMEpisodeDataRender {
    var episode: String { get }
    var name: String { get }
    var air_date: String { get }
}

final class RMCharacterEpisodeCollectionViewCellViewModel: Hashable, Equatable {
    private let episodeDataURL: URL?
    private var isFetching = false
    private var dataBlock: ((RMEpisodeDataRender) -> Void)?
    private var episode: RMEpisode? {
        didSet {
            guard let episode = episode else { return }
            dataBlock?(episode)
        }
    }
    
    init(episodeDataURL: URL?) {
        self.episodeDataURL = episodeDataURL
    }
    
    static func == (lhs: RMCharacterEpisodeCollectionViewCellViewModel, rhs: RMCharacterEpisodeCollectionViewCellViewModel) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataURL?.absoluteString ?? "")
    }
    
    public func registerForData(_ block: @escaping (RMEpisodeDataRender) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchEpisode() {
        guard !isFetching else {
            if let data = episode {
                dataBlock?(data)
            }
            return
        }
        
        guard let url = episodeDataURL, let rmRequest = RMRequest(url: url) else { return }
        isFetching = true
        
        RMService.shared.execute(rmRequest, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let success):
                print(String(describing: success.id))
                DispatchQueue.main.async {
                    self?.episode = success
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
}
