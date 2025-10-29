//
//  File.swift
//  BluProjectModel
//
//  Created by Amir Hossein on 29/10/2025.
//

import Foundation

public struct TransferError: Error, Codable {
    public let error: String
    
    static let unknowError = TransferError(error: "Unknown Error")
}
