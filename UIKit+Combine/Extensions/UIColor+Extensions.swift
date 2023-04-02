//
//  UIColor+Extensions.swift
//  UIKit+Combine
//
//  Created by Eren Demir on 2.04.2023.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            let red = CGFloat((hexNumber & 0xff0000) >> 16) / 255.0
            let green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255.0
            let blue = CGFloat(hexNumber & 0x0000ff) / 255.0
            let alpha = CGFloat(1.0)
            
            self.init(red: red, green: green, blue: blue, alpha: alpha)
            return
        }
        
        self.init(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
