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
    
    let httpService: HTTPServicing
    let service: CoinsServicing
    
    init() {
        self.httpService = HTTPService()
        self.service = CoinsService(httpService: httpService)
    }
    
    func buildInitialView() -> some View {
        let vm = CoinListViewModel(service: self.service)
        return AnyView(CoinListView(viewModel: vm))
    }
    
    func buildDestination(for route: Routes) -> some View {
        switch route {
        case .CoinDetails(let coin):
            return AnyView(CoinDetailView(coin: coin))
        case .Settings:
            return AnyView(SettingsView())
        case .Debugger:
            return AnyView(DebugView())
        }
    }
    
    func push(_ route: Routes) {
        path.append(route)
    }
    
    func reset() {
        path = NavigationPath()
    }
}
