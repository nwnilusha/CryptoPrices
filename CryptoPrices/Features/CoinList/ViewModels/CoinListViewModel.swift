//
//  CoinListViewModel.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import Foundation
import Combine

class CoinListViewModel: ObservableObject {
    @Published private(set) var coins: [Coin] = []
    @Published private(set) var filteredCoins: [Coin] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var pageNumber: Int = 1
    @Published var isSearching: Bool = false

    private var cancellables = Set<AnyCancellable>()
    
    private let service: CoinsServicing

    init(service: CoinsServicing) {
        self.service = service
        searchCoins()
    }

    func loadInitialData() async {
        if !self.coins.isEmpty {
            return
        } else {
            await fetchCryptoCurrencyData()
        }
    }
    
    @MainActor
    func refreshCurrencyData() async {
        self.coins = []
        self.filteredCoins = []
        self.pageNumber = 1
        await fetchCryptoCurrencyData()
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
            
            self.coins.append(contentsOf: currencyData)
            
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
    
    func searchCoins() {
        $searchText
            .sink { [weak self] text in
                guard let self = self else { return }
                if text.isEmpty {
                    self.isSearching = false
                    self.filteredCoins = self.coins
                } else {
                    self.isSearching = true
                    self.filteredCoins = self.coins.filter{ $0.name.lowercased().hasPrefix(text.lowercased()) || $0.symbol.lowercased().hasPrefix(text.lowercased())}
                }
            }
            .store(in: &cancellables)
    }
}
