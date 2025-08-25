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
                Toggle("Enable Logging", isOn: $isDebugEnabled)
                    .onChange(of: isDebugEnabled) { _, newValue in
                        AppConfig.isDebugModeEnabled = newValue
                    }
                    .padding()

                Button("Clear Logs") {
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
    }
}

#Preview {
    DebugView()
}
