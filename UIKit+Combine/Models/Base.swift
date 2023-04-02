//
//  Base.swift
//  UIKit+Combine
//
//  Created by Eren Demir on 1.04.2023.
//

import Foundation

// MARK: - BaseResult
struct BaseResult<T: Codable>: Codable {
    let page, perPage, total, totalPages: Int?
    let data: [T]?
    let support: Support?
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case data, support
    }
}

// MARK: - WithoutBaseResult
struct WithoutBaseResult<T: Codable>: Codable {
    let data: T?
    let support: Support?
    
    enum CodingKeys: String, CodingKey {
        case data, support
    }
}

// MARK: - Support
struct Support: Codable {
    let url: String?
    let text: String?
}
