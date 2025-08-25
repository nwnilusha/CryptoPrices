//
//  MockService.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 25/8/25.
//

import Foundation

struct MockService: CoinsServicing {
    func fetchCryptoPrices(pageNumber: Int) async throws -> [Coin] {
        return Coin.mockCoins
    }
}

class MockServiceError: CoinsServicing {
    func fetchCryptoPrices(pageNumber: Int) async throws -> [Coin] {
        throw RequestError.invalidURL
    }
}

class MockEmptyData: CoinsServicing {
    func fetchCryptoPrices(pageNumber: Int) async throws -> [Coin] {
        return []
    }
}
