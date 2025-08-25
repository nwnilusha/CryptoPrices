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
    private let logger = DebugLogger.shared

    init(service: CoinsServicing) {
        self.service = service
        logger.log("CoinListViewModel initialized")
        searchCoins()
    }

    func loadInitialData() async {
        logger.log("loadInitialData called")
        if !self.coins.isEmpty {
            logger.log("Skipping loadInitialData because coins are already loaded")
            return
        } else {
            await fetchCryptoCurrencyData()
        }
    }
    
    @MainActor
    func refreshCurrencyData() async {
        logger.log("Refreshing currency data")
        self.coins = []
        self.filteredCoins = []
        self.pageNumber = 1
        await fetchCryptoCurrencyData()
    }
    
    @MainActor
    func fetchCryptoCurrencyData() async {
        guard !isLoading else {
            logger.log("Fetch aborted: already loading")
            return
        }
        isLoading = true
        logger.log("Fetching cryptocurrency data for page \(pageNumber)")
        
        defer { isLoading = false }
        
        do {
            let currencyData = try await service.fetchCryptoPrices(pageNumber: self.pageNumber)
            logger.log("Fetched \(currencyData.count) coins")
            
            self.coins.append(contentsOf: currencyData)
            self.filteredCoins = self.coins
            self.pageNumber += 1
        } catch {
            if let apiError = error as? RequestError {
                errorMessage = apiError.errorDiscription
                logger.log("Fetch failed: \(apiError.errorDiscription)")
            } else {
                errorMessage = "Unknown error occurred"
                logger.log("Fetch failed: Unknown error")
            }
        }
    }
    
    func searchCoins() {
        $searchText
            .sink { [weak self] text in
                guard let self = self else { return }
                logger.log("Search text changed: \(text)")
                
                if text.isEmpty {
                    self.isSearching = false
                    self.filteredCoins = self.coins
                } else {
                    self.isSearching = true
                    self.filteredCoins = self.coins.filter {
                        $0.name.lowercased().hasPrefix(text.lowercased()) ||
                        $0.symbol.lowercased().hasPrefix(text.lowercased())
                    }
                    logger.log("Filtered coins: \(self.filteredCoins.count)")
                }
            }
            .store(in: &cancellables)
    }
}

