//
//  RMEpisodeDetailViewViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 11. 2. 2023..
//

import Foundation

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewViewModel {
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    private let endpointUrl: URL?
    private var dataTuple: (RMEpisode, [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum SectionType {
        case information(viewModel: [RMCharacterEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    public private(set) var cellViewModels: [SectionType] = []
    
    public func getCharacter(at index: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else { return nil}
        return dataTuple.1[index]
    }
        
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    public func fetchEpisodeData() {
        guard let url = endpointUrl, let request = RMRequest(url: url) else {
            return
        }
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let success):
                print(String(describing: success))
                self?.fetchRelatedCharacters(episode: success)
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else { return }
        let episode = dataTuple.0
        let characters = dataTuple.1
        
        var createdString = ""
        if let createdDate = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: createdDate)
        }
        
        cellViewModels = [
            .information(viewModel: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air date ", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString)
            ]),
            .characters(viewModel: characters.compactMap({ RMCharacterCollectionViewCellViewModel(characterName: $0.name, characterStatus: $0.status, characterImageUrl: URL(string: $0.image)) }))
        ]
        
    }
    
    private func fetchRelatedCharacters(episode: RMEpisode) {
        let characterUrls = episode.characters.compactMap({ URL(string: $0) })
        let requests: [RMRequest] = characterUrls.compactMap({ RMRequest(url: $0) })
        
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (
                episode,
                characters
            )
        }
    }
}
