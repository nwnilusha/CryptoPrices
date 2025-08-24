//
//  CryptoPricesApp.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import SwiftUI

@main
struct CryptoPricesApp: App {
    
    @AppStorage("selectedTheme") private var selectedTheme: String = "system"
    @StateObject private var coodinator = AppCoordinator()
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                coodinator.buildInitialView()
                    .navigationDestination(for: Routes.self) { route in
                        coodinator.buildDestination(for: route)
                    }
            }
            .environmentObject(coodinator)
            .preferredColorScheme(ThemeManager.currentColorScheme(selectedTheme: selectedTheme))
            if networkMonitor.showBanner {
                NetworkBannerView(bannerType: networkMonitor.bannerType)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
            }
        }
    }
}
