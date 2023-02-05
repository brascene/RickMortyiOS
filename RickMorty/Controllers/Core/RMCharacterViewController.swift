//
//  RMCharacterViewController.swift
//  RickMorty
//
//  Created by Dino Pelic on 5. 2. 2023..
//

import UIKit

final class RMCharacterViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        let request = RMRequest(endpoint: .character, pathComponents: ["1"], queryParams: [
        URLQueryItem(name: "name", value: "rick"), URLQueryItem(name: "status", value: "alive")])
        print(request.url)
    }
}
