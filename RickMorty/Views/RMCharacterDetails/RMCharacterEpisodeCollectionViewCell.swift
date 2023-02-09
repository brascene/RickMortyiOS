//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickMorty
//
//  Created by Dino Pelic on 9. 2. 2023..
//

import UIKit

class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterEpisodeCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupConstraints() {
        
    }
    
    public func setup(with viewModels: [RMCharacterEpisodeCollectionViewCellViewModel]) {
        
    }
}
