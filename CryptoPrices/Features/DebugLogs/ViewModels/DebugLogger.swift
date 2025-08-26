//
//  DebugLogger.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 25/8/25.
//

import Foundation

final class DebugLogger: ObservableObject {
    static let shared = DebugLogger()
    
    @Published private(set) var logs: [String] = []
    
    private init() {}
    
    func log(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
        guard AppConfig.isDebugModeEnabled else { return }
        
        let fileName = (file as NSString).lastPathComponent
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        let logMessage = "[\(timestamp)] \(fileName):\(line) \(function) → \(message)"

        if logs.count > 500 {
            logs.removeFirst()
        }
        
        DispatchQueue.main.async {
            self.logs.append(logMessage)
        }
        
        print(logMessage)
    }
    
    func clear() {
        logs.removeAll()
    }

    func saveLogsToFile() -> URL? {
        let fileManager = FileManager.default
        guard let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let logFileURL = docs.appendingPathComponent("CryptoPriceLogs.txt")
        let logText = logs.joined(separator: "\n")
        
        do {
            try logText.write(to: logFileURL, atomically: true, encoding: .utf8)
            print("Logs saved at: \(logFileURL.path)")
            return logFileURL
        } catch {
            print("Failed to save logs: \(error)")
            return nil
        }
    }
}

