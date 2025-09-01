//
//  CoinListViewModel_UnitTests.swift
//  CryptoPricesTests
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import XCTest
@testable import CryptoPrices

final class CoinListViewModel_UnitTests: XCTestCase {

    func test_init_withMockService_shouldFetchCoins() async {
        let viewModel = CoinListViewModel(service: MockService())
        await viewModel.loadInitialData()
        print("Coins count: \(viewModel.coins)")
        XCTAssertFalse(viewModel.coins.isEmpty, "Coins should not be empty after initialization")
        XCTAssertEqual(viewModel.filteredCoins.count, viewModel.coins.count)
    }
    
    func test_init_withEmptyService_shouldHaveNoCoins() async {
        let viewModel = CoinListViewModel(service: MockEmptyData())
        await viewModel.loadInitialData()
        
        XCTAssertTrue(viewModel.coins.isEmpty)
        XCTAssertTrue(viewModel.filteredCoins.isEmpty)
    }
    
    func test_loadInitialData_shouldNotReloadIfAlreadyLoaded() async {
        let viewModel = CoinListViewModel(service: MockService())
        await viewModel.loadInitialData()
        let firstLoadCount = viewModel.coins.count

        await viewModel.loadInitialData()
        
        XCTAssertEqual(viewModel.coins.count, firstLoadCount, "Coins should not reload if already present")
    }
    
    func test_refreshCurrencyData_shouldClearAndReload() async {
        let viewModel = CoinListViewModel(service: MockService())
        await viewModel.loadInitialData()
        XCTAssertFalse(viewModel.coins.isEmpty)
        
        await viewModel.refreshCurrencyData()
        
        XCTAssertFalse(viewModel.coins.isEmpty, "Coins should reload after refresh")
        XCTAssertEqual(viewModel.pageNumber, 2, "Page should increment after refresh fetch")
    }
    
    func test_fetchCryptoCurrencyData_success_shouldAppendResultsAndIncrementPage() async {
        let viewModel = CoinListViewModel(service: MockService())
        await viewModel.fetchCryptoCurrencyData()
        
        XCTAssertFalse(viewModel.coins.isEmpty)
        XCTAssertEqual(viewModel.pageNumber, 2, "Page should increment after successful fetch")
    }
    
    func test_fetchCryptoCurrencyData_failure_shouldSetRequestErrorMessage() async {
        let viewModel = CoinListViewModel(service: MockServiceError())
        await viewModel.fetchCryptoCurrencyData()
        
        XCTAssertNotNil(viewModel.errorMessage, "Error message should be set when fetch fails")
        XCTAssertTrue(viewModel.coins.isEmpty, "No coins should be added on failure")
    }
    
    func test_fetchCryptoCurrencyData_withUnknownError_shouldSetGenericErrorMessage() async {
        let viewModel = CoinListViewModel(service: MockServiceThrowsUnknown())

        await viewModel.fetchCryptoCurrencyData()

        XCTAssertNotNil(viewModel.errorMessage, "Error message should be set for unknown errors")
        XCTAssertEqual(viewModel.errorMessage, NSLocalizedString("coinlist.unknownError", comment: "Unknown error"))
        XCTAssertTrue(viewModel.coins.isEmpty, "No coins should be added on unknown error")
    }
    
    func test_fetchCryptoCurrencyData_emptyResponse_shouldNotIncrementPage() async {
        let viewModel = CoinListViewModel(service: MockEmptyData())
        await viewModel.fetchCryptoCurrencyData()
        
        XCTAssertTrue(viewModel.coins.isEmpty)
        XCTAssertEqual(viewModel.pageNumber, 1, "Page should not increment if no data returned")
    }
    
    func test_fetchCryptoCurrencyData_shouldNotFetchIfAlreadyLoading() async {
        let viewModel = CoinListViewModel(service: MockService())

        let task1 = Task { await viewModel.fetchCryptoCurrencyData() }

        let task2 = Task { await viewModel.fetchCryptoCurrencyData() }
        
        await task1.value
        await task2.value

        XCTAssertEqual(viewModel.pageNumber, 2, "Concurrent fetches should not double increment")
    }
    
    func test_searchCoins_withMatchingText_shouldFilterResults() async {
        let viewModel = CoinListViewModel(service: MockService())
        await viewModel.loadInitialData()
        
        viewModel.searchText = "bnb"
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertTrue(viewModel.isSearching)
        XCTAssertFalse(viewModel.filteredCoins.isEmpty, "Search should return results")
        XCTAssertTrue(viewModel.filteredCoins.allSatisfy {
            $0.symbol.lowercased().contains("bnb") || $0.name.lowercased().contains("bnb")
        })
    }
    
    func test_searchCoins_withEmptyText_shouldResetFilter() async {
        let viewModel = CoinListViewModel(service: MockService())
        await viewModel.loadInitialData()
        
        viewModel.searchText = "bnb"
        viewModel.searchText = ""
        
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertFalse(viewModel.isSearching)
        XCTAssertEqual(viewModel.filteredCoins.count, viewModel.coins.count, "Filter should reset when search text is empty")
    }
}

