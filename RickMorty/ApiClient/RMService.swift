//
//  RMService.swift
//  RickMorty
//
//  Created by Dino Pelic on 5. 2. 2023..
//

import Foundation

/// Primary API service object to get Rick Morty data
final class RMService {
    /// Shared singleton instance
    static let shared = RMService()
    
    private let cacheManager = RMApiCacheManager()
    
    /// Privatized constructor
    private init() {}
    
    enum REServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Send APi call
    /// - Parameters:
    ///     - request: Request instance
    ///     - completion: Callback with data or error
    public func execute<T: Codable>(_ request: RMRequest, expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        if let cachedData = cacheManager.cachedResponse(for: request.endpoint, url: request.url) {
            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            return
        }
        
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(REServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? REServiceError.failedToGetData))
                return
            }
            
            /// Decode response
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCache(for: request.endpoint, url: request.url, data: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: Private funcs
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil }
        var req = URLRequest(url: url)
        req.httpMethod = rmRequest.httpMethod
        return req
    }
}
