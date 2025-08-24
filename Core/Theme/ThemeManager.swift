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

struct ThemePicker: View {
    @AppStorage("AppTheme") private var appTheme: String = AppTheme.system.rawValue

    var body: some View {
        Picker("Theme", selection: Binding(
            get: { AppTheme(rawValue: appTheme) ?? .system },
            set: { appTheme = $0.rawValue }
        )) {
            ForEach(AppTheme.allCases) { theme in
                Text(theme.title).tag(theme)
            }
        }
        .pickerStyle(.segmented)
        .accessibilityLabel("Theme Picker")
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
