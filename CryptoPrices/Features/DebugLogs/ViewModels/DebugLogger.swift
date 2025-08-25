//
//  DebugLogger.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 25/8/25.
//

import Foundation
import Combine

final class DebugLogger: ObservableObject {
    static let shared = DebugLogger()
    
    @Published private(set) var logs: [String] = []
    
    private init() {}

    func log(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
        guard AppConfig.isDebugModeEnabled else { return }

        let fileName = (file as NSString).lastPathComponent
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        let logMessage = "[\(timestamp)] \(fileName):\(line) \(function) → \(message)"
        
        DispatchQueue.main.async {
            self.logs.append(logMessage)
        }

        print(logMessage)
    }

    func clear() {
        logs.removeAll()
    }
}
