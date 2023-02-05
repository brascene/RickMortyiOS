//
//  CharacterListViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 5. 2. 2023..
//

import Foundation
import UIKit

final class CharacterListViewModel: NSObject {
    func fetchCharacters() {
        RMService.shared.execute(.characterListRequest, expecting: RMGetAllCharactersResponse.self) { result in
            switch result {
            case .success(let model):
                print("Total: \(model.info.count)")
                print("result count: \(model.results.count)")
                break
            case .failure(let error):
                print(String(describing: error))
            }
        }

    }
}

extension CharacterListViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemGreen
        return cell
    }
}

extension CharacterListViewModel: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let size = (bounds.width - 30) / 2
        return CGSize(width: size, height: size * 1.5)
    }
}
