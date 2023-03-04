//
//  RMSearchViewController.swift
//  RickMorty
//
//  Created by Dino Pelic on 12. 2. 2023..
//

import UIKit

final class RMSearchViewController: UIViewController {
    struct Config {
        enum `Type` {
            case character
            case episode
            case location
            
            var title: String {
                switch self {
                case .character:
                    return "Search character"
                case .episode:
                    return "Search episode"
                case .location:
                    return "Search location"
                }
            }
        }
        
        let type: `Type`
    }
    
    private let config: Config
    
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = config.type.title
        view.backgroundColor = .systemBackground
    }
}
