//
//  File.swift
//  BluProjectModel
//
//  Created by Amir Hossein on 27/10/2025.
//

import Foundation

public protocol TransfersServiceProtocol {
    func fetchContacts(page: Int) async throws -> [Transfer]
}

