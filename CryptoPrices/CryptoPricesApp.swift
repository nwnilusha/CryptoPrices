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
            ZStack {
                NavigationStack(path: $coodinator.path) {
                    coodinator.buildInitialView()
                        .navigationDestination(for: Routes.self) { route in
                            coodinator.buildDestination(for: route)
                        }
                }
                .environmentObject(coodinator)
                .environmentObject(networkMonitor)
                .preferredColorScheme(ThemeManager.currentColorScheme(selectedTheme: selectedTheme))
                
                if networkMonitor.showBanner {
                    VStack {
                        NetworkBannerView(bannerType: networkMonitor.bannerType)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .zIndex(1)
                        Spacer()
                    }
                }
            }
            .animation(.easeInOut, value: networkMonitor.showBanner)
        }
    }
}

