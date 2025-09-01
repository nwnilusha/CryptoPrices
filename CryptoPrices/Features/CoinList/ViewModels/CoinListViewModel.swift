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
    
    //private var fetchTask: Task<Void, Never>?

    private var cancellables = Set<AnyCancellable>()
    private let service: CoinsServicing
    private let logger = DebugLogger.shared

    init(service: CoinsServicing) {
        self.service = service
        logger.log("CoinListViewModel initialized")
        bindSearch()
    }

    func loadInitialData() async {
        guard coins.isEmpty else {
            logger.log("Skipping loadInitialData because coins are already loaded")
            return
        }
        await fetchCryptoCurrencyData()
    }
    
    @MainActor
    func refreshCurrencyData() async {
        logger.log("Refreshing currency data")
        coins.removeAll()
        filteredCoins.removeAll()
        pageNumber = 1
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
            let currencyData = try await service.fetchCryptoPrices(pageNumber: pageNumber)
            logger.log("Fetched \(currencyData.count) coins")
            if currencyData.isEmpty {
                logger.log("No more data available.")
                return
            }
            coins.append(contentsOf: currencyData)
            applyFilter()
            pageNumber += 1
        } catch {
            if let apiError = error as? RequestError {
                errorMessage = apiError.errorDiscription
                logger.log("Fetch failed: \(apiError.errorDiscription)")
            } else {
                errorMessage = NSLocalizedString("coinlist.unknownError", comment: "Unknown error")
                logger.log("Fetch failed: Unknown error")
            }
        }
    }
    
    private func bindSearch() {
        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .sink { [weak self] _ in self?.applyFilter() }
            .store(in: &cancellables)
    }
    
    private func applyFilter() {
        if searchText.isEmpty {
            isSearching = false
            filteredCoins = coins
        } else {
            isSearching = true
            filteredCoins = coins.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.symbol.lowercased().contains(searchText.lowercased())
            }
            logger.log("Filtered coins: \(filteredCoins.count)")
        }
    }
}
