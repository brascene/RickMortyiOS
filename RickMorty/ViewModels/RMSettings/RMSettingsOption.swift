//
//  RMSettingsOption.swift
//  RickMorty
//
//  Created by Dino Pelic on 19. 2. 2023..
//

import Foundation
import UIKit

enum RMSettingsOption: CaseIterable {
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    var targetURL: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https://iosacademy.io")
        case .terms:
            return URL(string: "https://iosacademy.io")
        case .privacy:
            return URL(string: "https://iosacademy.io")
        case .apiReference:
            return URL(string: "https://iosacademy.io")
        case .viewSeries:
            return URL(string: "https://iosacademy.io")
        case .viewCode:
            return URL(string: "https://iosacademy.io")
        }
    }
    
    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Rate app"
        case .contactUs:
            return "Contact us"
        case .terms:
            return "Terms of service"
        case .privacy:
            return "Privacy policy"
        case .apiReference:
            return "API reference"
        case .viewSeries:
            return "View video series"
        case .viewCode:
            return "View app code"
        }
    }
    
    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemBlue
        case .contactUs:
            return .systemGreen
        case .terms:
            return .systemRed
        case .privacy:
            return .systemYellow
        case .apiReference:
            return .systemOrange
        case .viewSeries:
            return .systemPurple
        case .viewCode:
            return .systemPink
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
}
