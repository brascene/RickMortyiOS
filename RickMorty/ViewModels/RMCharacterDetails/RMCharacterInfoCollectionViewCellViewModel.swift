//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 9. 2. 2023..
//

import Foundation
import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()
    
    private let type: CharacterInfoCellType
    private let value: String
    
    public var title: String {
        return type.displayTitle
    }
    
    public var displayValue: String {
        if value.isEmpty {
            return "None"
        }
        if type == .created, let date = Self.dateFormatter.date(from: value) {
            return Self.shortDateFormatter.string(from: date)
        }
        return value
    }
    
    public var iconImage: UIImage? {
        return type.iconImage
    }
    
    public var tintColor: UIColor {
        return type.tintColor
    }
    
    enum CharacterInfoCellType {
        case status
        case gender
        case type
        case species
        case origin
        case created
        case location
        case episodeCount
        
        var displayTitle: String {
            switch self {
            case .status:
                return "Status"
            case .gender:
                return "Gender"
            case .type:
                return "Type"
            case .species:
                return "Species"
            case .origin:
                return "Origin"
            case .created:
                return "Created"
            case .location:
                return "Location"
            case .episodeCount:
                return "Episode count"
            }
        }
        
        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemBlue
            case .gender:
                return .systemPink
            case .type:
                return .systemGreen
            case .species:
                return .systemPurple
            case .origin:
                return .systemRed
            case .created:
                return .systemYellow
            case .location:
                return .systemCyan
            case .episodeCount:
                return .systemTeal
            }
        }
    }
    
    init(type: CharacterInfoCellType, value: String) {
        self.value = value
        self.type = type
    }
}
