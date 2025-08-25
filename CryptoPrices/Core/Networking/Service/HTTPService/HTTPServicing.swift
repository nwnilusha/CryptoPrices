//
//  HTTPServicing.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import Foundation

protocol HTTPServicing {
    func sendRequest <T: Decodable> (session: URLSession, endpoint: Endpoint, responseModel: T.Type) async throws -> T
}
