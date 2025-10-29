//
//  File.swift
//  BluProjectModel
//
//  Created by Amir Hossein on 27/10/2025.
//

import Foundation
import CoreNetwork

public class TransfersService: TransfersServiceProtocol {
    private let networker: NetworkerProtocol
    private let urlBuilder: URLBuilderProtocol
    
    
    public init(networker: NetworkerProtocol, urlBuilder: URLBuilderProtocol) {
        self.networker = networker
        self.urlBuilder = urlBuilder
    }
    
    public func fetchContacts(page: Int) async throws -> [Transfer] {
        let baseURL = try urlBuilder.getURL(with: Endpoints.getAllTransactions)
        let url = baseURL.appendingPathComponent("\(page)")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try await networker.fetchRequest(NetworkRequest<EmptyCodable, [Transfer]>(url: url, method: .get, decoder: decoder))
    }
}
