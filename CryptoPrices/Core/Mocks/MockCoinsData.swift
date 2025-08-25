//
//  MockCoinsData.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 25/8/25.
//

import Foundation

extension Coin {
    static var mockCoins: [Coin] {
        Bundle.main.decode([Coin].self, from: "mock_coins_response.json")
    }
}
