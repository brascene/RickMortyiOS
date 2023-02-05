//
//  Extensions.swift
//  RickMorty
//
//  Created by Dino Pelic on 5. 2. 2023..
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
