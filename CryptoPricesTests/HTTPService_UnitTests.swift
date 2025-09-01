//
//  HTTPService_UnitTests.swift
//  CryptoPricesTests
//
//  Created by Nilusha Niwanthaka Wimalasena on 31/8/25.
//

import XCTest
@testable import CryptoPrices

final class HTTPService_UnitTests: XCTestCase {
    
    func testSendRequest_Success() async throws {
        let httpService = HTTPService()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let sampleCoin = Coin.mockCoin
        let data = try JSONEncoder().encode([sampleCoin])
        
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://mockapi.com")!,
                                           statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        let result: [Coin] = try await httpService.sendRequest(
            session: session,
            endpoint: MockEndpoint(),
            responseModel: [Coin].self
        )
        
        XCTAssertEqual(result.first?.id, "ethereum")
    }
    
    func testSendRequest_Error() async throws {
        let httpService = HTTPService()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)

        MockURLProtocol.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }
        
        do {
            let _: [Coin] = try await httpService.sendRequest(
                session: session,
                endpoint: MockEndpoint(),
                responseModel: [Coin].self
            )
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is RequestError)
        }
    }
    
}
