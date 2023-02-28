//
//  RMSettingsCellViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 19. 2. 2023..
//

import Foundation
import UIKit

struct RMSettingsCellViewModel: Identifiable {
    var id = UUID()
    
    public let type: RMSettingsOption
    public let onTapHandler: (RMSettingsOption) -> Void
    
    public var image: UIImage? {
        return type.iconImage
    }
    public var title: String {
        return type.displayTitle
    }
    public var itemContainerColor: UIColor {
        return type.iconContainerColor
    }
    
    init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
}
