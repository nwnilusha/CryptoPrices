//
//  HTTPService.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 23/8/25.
//

import Foundation

struct HTTPService: HTTPServicing {
    
    private let logger = DebugLogger.shared
    
    func sendRequest<T>(
        session: URLSession,
        endpoint: any Endpoint,
        responseModel: T.Type
    ) async throws -> T where T: Decodable {
        
        var urlComponent = URLComponents()
        urlComponent.scheme = endpoint.scheme
        urlComponent.host = endpoint.host
        urlComponent.path = endpoint.path
        urlComponent.queryItems = endpoint.queryItems
        
        guard let url = urlComponent.url else {
            logger.log("HTTPService: Invalid URL for endpoint \(endpoint)")
            throw RequestError.invalidURL
        }
        logger.log("HTTPService: Sending request to \(url.absoluteString)")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        if let requestHeaders = endpoint.headers {
            urlRequest.allHTTPHeaderFields = requestHeaders
            logger.log("HTTPService: Headers - \(requestHeaders)")
        }
        
        if let requestBody = endpoint.body {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            logger.log("HTTPService: Request body added")
        }
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                logger.log("HTTPService: No response from server")
                throw RequestError.noResponse
            }
            
            logger.log("HTTPService: Response status code - \(httpResponse.statusCode)")
            
            switch httpResponse.statusCode {
            case 200..<300: break
            case 401: throw RequestError.unauthorized
            case 425: throw RequestError.workInProgress
            default:
                throw RequestError.unexpectedStatusCode
            }
            
            guard !data.isEmpty else {
                logger.log("HTTPService: Empty response data")
                throw RequestError.emptyResponse
            }
            
            do {
                let decodeData = try JSONDecoder().decode(T.self, from: data)
                logger.log("HTTPService: Successfully decoded response")
                return decodeData
            } catch {
                logger.log("HTTPService: Decoding error - \(error.localizedDescription)")
                throw RequestError.decodingError(error.localizedDescription)
            }
        } catch {
            logger.log("HTTPService: Data task error - \(error.localizedDescription)")
            throw RequestError.dataTaskError(error.localizedDescription)
        }
    }
}

enum RequestError: Error {
    case invalidURL
    case noResponse
    case emptyResponse
    case unauthorized
    case unexpectedStatusCode
    case workInProgress
    case dataTaskError(String)
    case curruptData
    case decodingError(String)
    
    var errorDiscription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noResponse:
            return "No Response"
        case .emptyResponse:
            return "Empty Response"
        case .dataTaskError(let message):
            return message
        case .curruptData:
            return "Currupt Data"
        case .decodingError(let message):
            return message
        case .unauthorized:
            return "Unauthorized"
        case .unexpectedStatusCode:
            return "Unexpected Status Code"
        case .workInProgress:
            return "Work In Progress"
        }
    }
}
