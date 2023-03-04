//
//  RMLocationDetailsViewViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 4. 3. 2023..
//

import Foundation

protocol RMLocationDetailsViewViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
}

final class RMLocationDetailsViewViewModel {
    public weak var delegate: RMLocationDetailsViewViewModelDelegate?
    private let endpointUrl: URL?
    private var dataTuple: (RMLocation, [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }
    
    enum SectionType {
        case information(viewModel: [RMEpisodeInfoCollectionViewCellViewModel])
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
    
    public func fetchLocationData() {
        guard let url = endpointUrl, let request = RMRequest(url: url) else {
            return
        }
        RMService.shared.execute(request, expecting: RMLocation.self) { [weak self] result in
            switch result {
            case .success(let success):
                print(String(describing: success))
                self?.fetchRelatedCharacters(location: success)
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else { return }
        let location = dataTuple.0
        let characters = dataTuple.1
        
        var createdString = ""
        if let createdDate = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: createdDate)
        }
        
        cellViewModels = [
            .information(viewModel: [
                .init(title: "Location Name", value: location.name),
                .init(title: "Type ", value: location.type),
                .init(title: "Dimension", value: location.dimension),
                .init(title: "Created", value: createdString)
            ]),
            .characters(viewModel: characters.compactMap({ RMCharacterCollectionViewCellViewModel(characterName: $0.name, characterStatus: $0.status, characterImageUrl: URL(string: $0.image)) }))
        ]
        
    }
    
    private func fetchRelatedCharacters(location: RMLocation) {
        let characterUrls = location.residents.compactMap({ URL(string: $0) })
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
                location,
                characters
            )
        }
    }
}
