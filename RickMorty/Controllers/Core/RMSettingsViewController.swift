//
//  RMSettingsViewController.swift
//  RickMorty
//
//  Created by Dino Pelic on 5. 2. 2023..
//

import SwiftUI
import UIKit
import SafariServices
import StoreKit

final class RMSettingsViewController: UIViewController {
    private var settingsSwiftUIContoller: UIHostingController<RMSettingsView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
        addSwiftUIController()
    }
    
    private func addSwiftUIController() {
        let settingsSwiftUIContoller = UIHostingController(rootView: RMSettingsView(viewModel: RMSettingsViewViewModel(cellViewModels: RMSettingsOption.allCases.compactMap({ RMSettingsCellViewModel(type: $0) { [weak self] option in
            self?.handleTap(option: option)
        } }))))
        
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
        
        self.settingsSwiftUIContoller = settingsSwiftUIContoller
    }
    
    private func handleTap(option: RMSettingsOption) {
        guard Thread.current.isMainThread else { return }
        if let url = option.targetURL {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        } else if option == .rateApp {
            Task { @MainActor [weak self] in
                if let scene = self?.view.window?.windowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
        }
    }
}
