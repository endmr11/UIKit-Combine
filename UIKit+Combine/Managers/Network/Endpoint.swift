//
//  Endpoint.swift
//  UIKit+Combine
//
//  Created by Eren Demir on 1.04.2023.
//

import Foundation

enum Endpoint {
    enum Constant {
        static let baseURL = "https://reqres.in/api"
    }
    case unknown(querys: String)
    var url: String {
        switch self {
        case .unknown(let querys):
            return "\(Constant.baseURL)/unknown/\(querys)"
        }
    }
}
