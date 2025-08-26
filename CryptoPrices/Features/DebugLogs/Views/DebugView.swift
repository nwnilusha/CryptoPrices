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
    @State private var showSaveConfirmation = false
    @State private var savedFileURL: URL?

    var body: some View {
        VStack(alignment: .leading) {
            Toggle(
                NSLocalizedString("debug.enableLogging", comment: "Enable Logging toggle"),
                isOn: $isDebugEnabled
            )
            .onChange(of: isDebugEnabled) { _, newValue in
                AppConfig.isDebugModeEnabled = newValue
            }
            .padding()

            HStack {
                Button(NSLocalizedString("debug.clearLogs", comment: "Clear logs button")) {
                    logger.clear()
                }
                .buttonStyle(.borderedProminent)
                
                Button(NSLocalizedString("debug.saveLogs", comment: "Save logs button")) {
                    if let fileURL = logger.saveLogsToFile() {
                        savedFileURL = fileURL
                        showSaveConfirmation = true
                    }
                }
                .buttonStyle(.borderedProminent)
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
        .alert(
            NSLocalizedString("debug.logsSaved", comment: "Logs saved alert title"),
            isPresented: $showSaveConfirmation,
            actions: {
                Button("OK", role: .cancel) {}
            },
            message: {
                if let url = savedFileURL {
                    Text(String(format: NSLocalizedString("debug.logsSavedMessage", comment: "Logs saved message"), url.lastPathComponent))
                } else {
                    Text(NSLocalizedString("debug.logsSavedUnknown", comment: "Logs saved unknown message"))
                }
            }
        )
    }
}


#Preview {
    DebugView()
}
