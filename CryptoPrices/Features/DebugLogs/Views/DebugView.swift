//
//  DebugView.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 25/8/25.
//

import SwiftUI

struct DebugView: View {
    @ObservedObject private var logger = DebugLogger.shared
    @State private var isDebugEnabled = AppConfig.isDebugModeEnabled

    var body: some View {
        VStack(alignment: .leading) {
            Toggle(NSLocalizedString("debug.enableLogging", comment: "Enable Logging toggle"), isOn: $isDebugEnabled)
                .onChange(of: isDebugEnabled) { _, newValue in
                    AppConfig.isDebugModeEnabled = newValue
                }
                .padding()

            Button(NSLocalizedString("debug.clearLogs", comment: "Clear logs button")) {
                logger.clear()
            }
            .padding(.horizontal)
            
            List(logger.logs.reversed(), id: \.self) { log in
                Text(log)
                    .font(.system(size: 12, design: .monospaced))
                    .padding(.vertical, 2)
            }
            .frame(maxHeight: .infinity)
        }
        .navigationTitle(NSLocalizedString("menu.debugLogs", comment: "Debug logs view title"))
    }
}

#Preview {
    DebugView()
}
