//
//  RMSettingsViewController.swift
//  RickMorty
//
//  Created by Dino Pelic on 5. 2. 2023..
//

import SwiftUI
import UIKit

final class RMSettingsViewController: UIViewController {
    private let viewModel = RMSettingsViewViewModel(cellViewModels: RMSettingsOption.allCases.compactMap({ RMSettingsCellViewModel(type: $0) }))
    
    private let settingsSwiftUIContoller = UIHostingController(rootView: RMSettingsView(viewModel: RMSettingsViewViewModel(cellViewModels: RMSettingsOption.allCases.compactMap({ RMSettingsCellViewModel(type: $0) }))))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
        addSwiftUIController()
    }
    
    private func addSwiftUIController() {
        addChild(settingsSwiftUIContoller)
        settingsSwiftUIContoller.didMove(toParent: self)
        view.addSubview(settingsSwiftUIContoller.view)
        settingsSwiftUIContoller.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsSwiftUIContoller.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIContoller.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            settingsSwiftUIContoller.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsSwiftUIContoller.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
