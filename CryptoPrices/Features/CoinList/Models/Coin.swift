//
//  Coin.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import Foundation

struct Coin: Identifiable, Codable, Hashable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let marketCap: Double?
    let marketCapRank: Int?
    let fullyDilutedValuation: Double?
    let totalVolume: Double?
    let high24h: Double?
    let low24h: Double?
    let priceChange24h: Double?
    let priceChangePercentage24h: Double?
    let marketCapChange24h: Double?
    let marketCapChangePercentage24h: Double?
    let circulatingSupply: Double?
    let totalSupply: Double?
    let maxSupply: Double?
    let ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl: Double?
    let atlChangePercentage: Double?
    let atlDate: String?
    let roi: Roi?
    let lastUpdated: String?
}

struct Roi: Codable, Hashable {
    let times: Double?
    let currency: String?
    let percentage: Double?
}

extension Coin {
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24h = "high_24h"
        case low24h = "low_24h"
        case priceChange24h = "price_change_24h"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case marketCapChange24h = "market_cap_change_24h"
        case marketCapChangePercentage24h = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case roi
        case lastUpdated = "last_updated"
    }
}

extension Coin {
    static let mockCoin = Coin(
        id: "ethereum",
        symbol: "eth",
        name: "Ethereum",
        image: "https://assets.coingecko.com/coins/images/279/large/ethereum.png",
        currentPrice: 3200.75,
        marketCap: 380_000_000_000,
        marketCapRank: 2,
        fullyDilutedValuation: 420_000_000_000,
        totalVolume: 25_000_000_000,
        high24h: 3300.50,
        low24h: 3150.00,
        priceChange24h: -45.25,
        priceChangePercentage24h: -1.39,
        marketCapChange24h: -5_000_000_000,
        marketCapChangePercentage24h: -1.30,
        circulatingSupply: 118_000_000,
        totalSupply: nil,
        maxSupply: nil,
        ath: 4356.00,
        athChangePercentage: -26.50,
        athDate: "2021-11-10",
        atl: 0.4329,
        atlChangePercentage: 739000,
        atlDate: "2015-10-20",
        roi: Roi(times: 80.0, currency: "usd", percentage: 8000.0),
        lastUpdated: "2025-08-28T12:00:00Z"
    )
}

