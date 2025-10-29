//
//  File.swift
//  CoreNetwork
//
//  Created by Amir Hossein on 27/10/2025.
//

import Foundation

public struct NetworkRequest<REQUEST: Encodable, RESPONSE: Decodable & Sendable> {
    public let url: URL
    public let method: HttpMethod
    public let parameters: REQUEST?
    public let decoder: JSONDecoder
    
    public init(url: URL, method: HttpMethod, parameters: REQUEST? = nil, decoder: JSONDecoder = .init()) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.decoder = decoder
    }
}
