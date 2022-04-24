//
//  UIFont + Extensions.swift
//  RickAndMorty
//
//  Created by Тимур Ахметов on 24.04.2022.
//

import UIKit

extension UIFont {
    
    //MARK: - Regular
    
    static func getRegularLabel16() -> UIFont? {
        return UIFont.init(name: "LabGrotesque-Regular", size: 16)
    }
    
    static func getRegularLabel18() -> UIFont? {
        return UIFont.init(name: "LabGrotesque-Regular", size: 18)
    }
    
    //MARK: - Bold
    
    static func getBoldLabel18() -> UIFont? {
        return UIFont.init(name: "LabGrotesqueMono-Bold", size: 18)
    }
    
    static func getBoldLabel20() -> UIFont? {
        return UIFont.init(name: "LabGrotesqueMono-Bold", size: 20)
    }

    static func getBoldLabel22() -> UIFont? {
        return UIFont.init(name: "LabGrotesqueMono-Bold", size: 22)
    }
}

