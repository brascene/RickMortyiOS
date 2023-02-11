//
//  RMEpisodeDetailViewController.swift
//  RickMorty
//
//  Created by Dino Pelic on 11. 2. 2023..
//

import UIKit

final class RMEpisodeDetailViewController: UIViewController {
    private let url: URL?
    
    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
    }
}
