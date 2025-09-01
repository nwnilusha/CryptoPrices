//
//  AppConfig.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 25/8/25.
//

import Foundation

struct AppConfig {
    static var isDebugModeEnabled: Bool {
        get {
            #if DEBUG
            let userDefaultsValue = UserDefaults.standard.bool(forKey: "debug_mode")
            return userDefaultsValue
            #else
            return false
            #endif
        }
        set {
            #if DEBUG
            UserDefaults.standard.set(newValue, forKey: "debug_mode")
            #endif
        }
    }
}
