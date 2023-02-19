//
//  RMSettingsCellViewModel.swift
//  RickMorty
//
//  Created by Dino Pelic on 19. 2. 2023..
//

import Foundation
import UIKit

struct RMSettingsCellViewModel: Identifiable, Hashable {
    var id = UUID()
    
    private let type: RMSettingsOption
    
    public var image: UIImage? {
        return type.iconImage
    }
    public var title: String {
        return type.displayTitle
    }
    public var itemContainerColor: UIColor {
        return type.iconContainerColor
    }
    
    init(type: RMSettingsOption) {
        self.type = type
    }
}
