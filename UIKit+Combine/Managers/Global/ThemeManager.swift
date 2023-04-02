//
//  ThemeManager.swift
//  UIKit+Combine
//
//  Created by Eren Demir on 2.04.2023.
//

import Foundation
import Combine

protocol IThemeManager{
    var themeColor: CurrentValueSubject<String?, Never> { get }
}

final class ThemeManager: IThemeManager{
    static let shared = ThemeManager()
    var themeColor = CurrentValueSubject<String?, Never>(nil)
}
