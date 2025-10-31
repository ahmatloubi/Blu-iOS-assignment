//
//  File.swift
//  BluProjectModel
//
//  Created by Amir Hossein on 29/10/2025.
//

import Foundation

public struct MoreInfo: Codable, Sendable, Hashable {
    public let numberOfTransfers: Int
    public let totalTransfer: Int
    
    public init(numberOfTransfers: Int, totalTransfer: Int) {
        self.numberOfTransfers = numberOfTransfers
        self.totalTransfer = totalTransfer
    }
}
