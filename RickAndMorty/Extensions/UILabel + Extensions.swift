//
//  UILabel + Extensions.swift
//  RickAndMorty
//
//  Created by Тимур Ахметов on 24.04.2022.
//

import UIKit

extension UILabel {
    convenience init(text: String = "", font: UIFont?, color: UIColor) {
        self.init()
        
        self.numberOfLines = 2
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.7
        self.text = text
        self.font = font
        self.textColor = color
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
