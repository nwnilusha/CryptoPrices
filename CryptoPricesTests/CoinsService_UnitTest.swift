//
//  CoinsService_UnitTest.swift
//  CryptoPricesTests
//
//  Created by Nilusha Niwanthaka Wimalasena on 31/8/25.
//

import XCTest
@testable import CryptoPrices

final class CoinsService_UnitTest: XCTestCase {
    
    func testFetchCryptoPricesSuccess() async throws {
        let mockHTTPService = MockHTTPService()
        let coinsService = CoinsService(httpService: mockHTTPService)
        let expectedCoins = Coin.mockCoins
        mockHTTPService.result = .success(expectedCoins)
        
        let coins = try await coinsService.fetchCryptoPrices(pageNumber: 1)
        
        XCTAssertEqual(coins.count, 10)
        XCTAssertEqual(coins.first?.id, "binancecoin")
    }

    func testFetchCryptoPricesFailure() async {
        let mockHTTPService = MockHTTPService()
        let coinsService = CoinsService(httpService: mockHTTPService)
        mockHTTPService.result = .failure(RequestError.noResponse)
        
        do {
            _ = try await coinsService.fetchCryptoPrices(pageNumber: 1)
            XCTFail("Expected error, but got success")
        } catch {
            XCTAssertTrue(error is RequestError)
        }
    }
    
}
