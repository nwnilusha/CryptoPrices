//
//  CoinsService.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import Foundation

struct CoinsService: CoinsServicing {
    
    let httpService: HTTPServicing
    private let logger = DebugLogger.shared
    
    func fetchCryptoPrices(pageNumber: Int) async throws -> [Coin] {
        logger.log("CoinsService: Fetching crypto prices for page \(pageNumber)")
        
        do {
            let response = try await httpService.sendRequest(
                session: URLSession.shared,
                endpoint: ApiEndpoint.cryptoPrices(pageNumber),
                responseModel: [Coin].self
            )
            logger.log("CoinsService: Successfully fetched \(response.count) coins")
            return response
        } catch {
            logger.log("CoinsService: Failed fetching crypto prices - \(error.localizedDescription)")
            throw error
        }
    }
}
