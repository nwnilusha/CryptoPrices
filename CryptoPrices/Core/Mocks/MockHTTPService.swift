//
//  MockHTTPService.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 31/8/25.
//

import Foundation

final class MockHTTPService: HTTPServicing {
    var result: Result<[Coin], Error>?
    
    func sendRequest<T>(
        session: URLSession,
        endpoint: Endpoint,
        responseModel: T.Type
    ) async throws -> T where T : Decodable {
        switch result {
        case .success(let coins as T):
            return coins
        case .failure(let error):
            throw error
        default:
            fatalError("Unexpected type")
        }
    }
}
