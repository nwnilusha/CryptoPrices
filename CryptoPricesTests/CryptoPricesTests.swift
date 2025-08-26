//
//  CryptoPricesTests.swift
//  CryptoPricesTests
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import XCTest
@testable import CryptoPrices

final class CryptoPricesTests: XCTestCase {

    func test_init_withMockService_shouldFetchCoins() async {
            var viewModel = CoinListViewModel(service: MockService())
            await viewModel.loadInitialData()
            XCTAssertFalse(viewModel.coins.isEmpty, "Coins should not be empty after initialization")
            XCTAssertEqual(viewModel.filteredCoins.count, viewModel.coins.count)
        }
        
        func test_init_withEmptyService_shouldHaveNoCoins() async {

            var viewModel = CoinListViewModel(service: MockEmptyData())
            await viewModel.loadInitialData()

            XCTAssertTrue(viewModel.coins.isEmpty)
            XCTAssertTrue(viewModel.filteredCoins.isEmpty)
        }
        
        func test_loadInitialData_shouldNotReloadIfAlreadyLoaded() async {
            var viewModel = CoinListViewModel(service: MockService())
            await viewModel.loadInitialData()
            let firstLoadCount = viewModel.coins.count

            await viewModel.loadInitialData()

            XCTAssertEqual(viewModel.coins.count, firstLoadCount, "Coins should not reload if already present")
        }
        
        func test_refreshCurrencyData_shouldClearAndReload() async {
            var viewModel = CoinListViewModel(service: MockService())
            await viewModel.loadInitialData()
            XCTAssertFalse(viewModel.coins.isEmpty)

            await viewModel.refreshCurrencyData()

            XCTAssertFalse(viewModel.coins.isEmpty, "Coins should reload after refresh")
            XCTAssertEqual(viewModel.pageNumber, 2, "Page should increment after refresh fetch")
        }
        
        func test_fetchCryptoCurrencyData_failure_shouldSetErrorMessage() async {
            var viewModel = CoinListViewModel(service: MockServiceError())

            await viewModel.fetchCryptoCurrencyData()

            XCTAssertNotNil(viewModel.errorMessage, "Error message should be set when fetch fails")
            XCTAssertTrue(viewModel.coins.isEmpty, "No coins should be added on failure")
        }
        
        func test_searchCoins_withMatchingText_shouldFilterResults() async {
            var viewModel = CoinListViewModel(service: MockService())
            await viewModel.loadInitialData()

            viewModel.searchText = "bnb"

            let expectation = XCTestExpectation(description: "Wait for search filter")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                expectation.fulfill()
            }
            await fulfillment(of: [expectation], timeout: 1.0)

            XCTAssertTrue(viewModel.isSearching)
            XCTAssertFalse(viewModel.filteredCoins.isEmpty, "Search should return results")
            XCTAssertTrue(viewModel.filteredCoins.allSatisfy { $0.symbol.lowercased().hasPrefix("bnb") || $0.name.lowercased().hasPrefix("bnb") })
        }
        
        func test_searchCoins_withEmptyText_shouldResetFilter() async {
            var viewModel = CoinListViewModel(service: MockService())
            await viewModel.loadInitialData()
            viewModel.searchText = "bnb"

            let expectation = XCTestExpectation(description: "Wait for initial search")
            viewModel.searchText = ""

            do {
                try await Task.sleep(for: .seconds(0.6))
                XCTAssertFalse(viewModel.isSearching)
                XCTAssertEqual(viewModel.filteredCoins.count, viewModel.coins.count, "Filter should reset when search text is empty")
            } catch {
                XCTFail("Error: \(error)")
            }
        }
        
        func test_fetchCryptoCurrencyData_shouldAppendResultsAndIncrementPage() async {
            var viewModel = CoinListViewModel(service: MockService())
            

            await viewModel.fetchCryptoCurrencyData()

            XCTAssertFalse(viewModel.coins.isEmpty)
            XCTAssertEqual(viewModel.pageNumber, 2, "Page should increment after successful fetch")
        }

}
