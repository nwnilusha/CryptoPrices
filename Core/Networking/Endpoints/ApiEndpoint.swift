//
//  ApiEndpoint.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import Foundation

enum ApiEndpoint: Endpoint {
    case cryptoPrices(Int)
    
    var scheme: String {
        switch self {
        case .cryptoPrices:
            return "https"
        }
    }
    
    var host: String {
        switch self {
        case .cryptoPrices:
            return "api.coingecko.com"
        }
    }
    
    var path: String {
        switch self {
        case .cryptoPrices:
            return "/api/v3/coins/markets"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .cryptoPrices:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .cryptoPrices:
            return nil
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .cryptoPrices:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .cryptoPrices(let page):
            return [
                URLQueryItem(name: "vs_currency", value: "eur"),
                URLQueryItem(name: "order", value: "market_cap_desc"),
                URLQueryItem(name: "per_page", value: "100"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "sparkline", value: "false")
            ]
        }
    }
}
