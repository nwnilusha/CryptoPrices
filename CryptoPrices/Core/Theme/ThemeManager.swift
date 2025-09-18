//
//  ThemeManager.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 24/8/25.
//

import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system, light, dark
    var id: String { rawValue }

    var title: String {
        switch self { case .system: return "System"; case .light: return "Light"; case .dark: return "Dark" }
    }

    var colorScheme: ColorScheme? {
        switch self { case .system: return nil; case .light: return .light; case .dark: return .dark }
    }
}

class ThemeManager {
    static func currentColorScheme(selectedTheme: String) -> ColorScheme? {
        switch AppTheme(rawValue: selectedTheme) ?? .system {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

//class ThemeManager {
//    static func currentColorScheme(selectedTheme: String) -> ColorScheme? {
//        if selectedTheme == "system" {
//            return nil
//        } else if selectedTheme == "light" {
//            return .light
//        } else {
//            return .dark
//        }
//    }
//}
