//
//  SettingsView.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedTheme") private var selectedTheme: String = "system"
    private let logger = DebugLogger.shared
    
    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("settings.section.appearance", comment: "Appearance section header"))) {
                Picker(NSLocalizedString("settings.theme", comment: "App theme picker label"), selection: $selectedTheme) {
                    Text(NSLocalizedString("settings.theme.system", comment: "System theme")).tag("system")
                    Text(NSLocalizedString("settings.theme.light", comment: "Light theme")).tag("light")
                    Text(NSLocalizedString("settings.theme.dark", comment: "Dark theme")).tag("dark")
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedTheme) { _, newValue in
                    logger.log("Changed theme to \(newValue)")
                }
            }
            
            Section(header: Text(NSLocalizedString("settings.section.about", comment: "About section header"))) {
                HStack {
                    Text(NSLocalizedString("settings.appVersion", comment: "App version label"))
                    Spacer()
                    Text(Bundle.main.appVersion)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text(NSLocalizedString("settings.buildNumber", comment: "Build number label"))
                    Spacer()
                    Text(Bundle.main.buildNumber)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle(NSLocalizedString("settings.title", comment: "Settings view title"))
        .onAppear {
            logger.log("Opened SettingsView")
        }
        .onDisappear {
            logger.log("Closed SettingsView")
        }
    }
}

#Preview {
    SettingsView()
}
