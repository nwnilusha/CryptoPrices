//
//  CryptoPricesApp.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import SwiftUI

@main
struct CryptoPricesApp: App {
    @StateObject private var coodinator = AppCoordinator()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                coodinator.buildInitialView()
                    .navigationDestination(for: Routes.self) { route in
                        coodinator.buildDestination(for: route)
                    }
            }
            .environmentObject(coodinator)
        }
    }
}
