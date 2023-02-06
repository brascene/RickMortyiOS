//
//  CharacterListViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 5. 2. 2023..
//

import Foundation
import UIKit

protocol RMCharacterListViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
}

final class RMCharacterListViewModel: NSObject {
    private var characters: [RMCharacter] = [] {
        didSet {
            for char in characters {
                let vm = RMCharacterCollectionViewCellViewModel(characterName: char.name, characterStatus: char.status, characterImageUrl: URL(string: char.image))
                cellViewModels.append(vm)
            }
        }
    }
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    public weak var delegate: RMCharacterListViewModelDelegate?
    
    public func fetchCharacters() {
        RMService.shared.execute(.characterListRequest, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                print("Total: \(model.info.count)")
                print("result count: \(model.results.count)")
                self?.characters = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
                break
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension RMCharacterListViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
}

extension RMCharacterListViewModel: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let size = (bounds.width - 30) / 2
        return CGSize(width: size, height: size * 1.5)
    }
}
