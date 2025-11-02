//
//  File.swift
//  BluProjectModel
//
//  Created by Amir Hossein on 28/10/2025.
//

import Foundation

enum URLBuilderError: Error {
    case invalidURL
}

public class URLBuilder: URLBuilderProtocol {
    private let baseURL: String
    
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    public func getURL(with endpoint: Endpoints) throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseURL
        urlComponents.path = endpoint.rawValue
        guard let url = urlComponents.url else {
            throw URLBuilderError.invalidURL
        }
        return url
    }
    
    
}
