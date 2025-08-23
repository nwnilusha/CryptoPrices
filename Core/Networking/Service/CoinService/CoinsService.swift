//
//  CoinsService.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import Foundation

struct CoinsService: CoinsServicing {
    
    let httpService: HTTPServicing
    
    func fetchCryptoPrices(pageNumber: Int) async throws -> [Coin] {
        do {
            let response = try await httpService.sendRequest(
                session: URLSession.shared,
                endpoint: ApiEndpoint.cryptoPrices(pageNumber),
                responseModel: [Coin].self
            )
            return response
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}
