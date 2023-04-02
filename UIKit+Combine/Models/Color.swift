//
//  ColorResult.swift
//  UIKit+Combine
//
//  Created by Eren Demir on 1.04.2023.
//

import Foundation

// MARK: - ColorModel
struct ColorModel:Codable {
    let id: Int?
    let name: String?
    let year: Int?
    let color, pantoneValue: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, year, color
        case pantoneValue = "pantone_value"
    }
}


