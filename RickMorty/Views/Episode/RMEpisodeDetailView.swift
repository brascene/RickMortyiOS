//
//  RMEpisodeDetailView.swift
//  RickMorty
//
//  Created by Dino Pelic on 11. 2. 2023..
//

import UIKit

final class RMEpisodeDetailView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
}
