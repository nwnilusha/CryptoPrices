//
//  Servicing.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import Foundation

protocol CoinsServicing {
    func fetchCryptoPrices(pageNumber: Int) async throws -> [Coin]
}
