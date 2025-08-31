//
//  AppCoordinator.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import Foundation
import SwiftUI

class AppCoordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var showSplashScreen = true
    
    let httpService: HTTPServicing
    let service: CoinsServicing
    private let logger = DebugLogger.shared
    
    init() {
        logger.log("AppCoordinator: Initializing")
        self.httpService = HTTPService()
        if CommandLine.arguments.contains("--uitesting") {
            self.service = MockService()
        } else {
            self.service = CoinsService(httpService: httpService)
        }
        
    }
    
    func buildSplashScreen() -> some View {
        logger.log("AppCoordinator: Building SplashScreen")
        return AnyView(SplashScreenView())
    }
    
    func buildInitialView() -> some View {
        logger.log("AppCoordinator: Building initial CoinListView")
        let vm = CoinListViewModel(service: self.service)
        return AnyView(CoinListView(viewModel: vm))
    }
    
    func buildDestination(for route: Routes) -> some View {
        logger.log("AppCoordinator: Building destination for route \(route)")
        switch route {
        case .Settings:
            return AnyView(SettingsView())
        case .Debugger:
            return AnyView(DebugView())
        }
    }
    
    func push(_ route: Routes) {
        logger.log("AppCoordinator: Pushing route \(route)")
        path.append(route)
    }
    
    func reset() {
        logger.log("AppCoordinator: Resetting navigation path")
        path = NavigationPath()
    }
    
    func hideSplashScreen() {
        logger.log("AppCoordinator: Hiding splash screen")
        withAnimation(.easeOut(duration: 0.5)) {
            showSplashScreen = false
        }
    }
}

