//
//  File.swift
//  CoreNetwork
//
//  Created by Amir Hossein on 27/10/2025.
//

import Foundation

public protocol NetworkerProtocol {
    func fetchRequest<REQUEST, RESPONSE>(_ request: NetworkRequest<REQUEST,RESPONSE>) async throws -> RESPONSE where REQUEST: Encodable, RESPONSE: Decodable & Sendable
}
