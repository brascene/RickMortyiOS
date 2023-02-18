//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickMorty
//
//  Created by Dino Pelic on 18. 2. 2023..
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMEpisodeInfoCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupLayout() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    public func configure(with viewModel: RMCharacterEpisodeInfoCollectionViewCellViewModel) {
        
    }
}
