//
//  RMLocationTableViewCell.swift
//  RickMorty
//
//  Created by Dino Pelic on 2. 3. 2023..
//

import UIKit

class RMLocationTableViewCell: UITableViewCell {
    static let cellIdentiier = "RMLocationTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: Self.cellIdentiier)
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: RMLocationTableViewCellViewModel) {
        
    }
}
