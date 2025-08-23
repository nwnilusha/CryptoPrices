//
//  CoinListViewModel.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import Foundation


class CoinListViewModel: ObservableObject {
    @Published private(set) var coins: [Coin] = []
    @Published private(set) var filteredCoins: [Coin] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var pageNumber: Int = 1

    private let service: CoinsServicing

    init(service: CoinsServicing) {
        self.service = service
    }
    
    @MainActor
    func fetchCryptoCurrencyData() async {
        guard !isLoading else { return }
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let currencyData = try await service.fetchCryptoPrices(pageNumber: self.pageNumber)
            
            if self.coins.isEmpty {
                self.coins = currencyData
                print("Coins Count : \(currencyData.count)")
            } else {
                self.coins.append(contentsOf: currencyData)
            }
            
            self.filteredCoins = self.coins
            self.pageNumber += 1
            
        } catch {
            if let apiError = error as? RequestError {
                errorMessage = apiError.errorDiscription
                print("Fetch data failed: \(apiError.errorDiscription)")
            } else {
                errorMessage = "Unknown error occurred"
            }
        }
    }
}
