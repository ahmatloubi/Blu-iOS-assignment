//
//  File.swift
//  BluProjectModel
//
//  Created by Amir Hossein on 29/10/2025.
//

import Foundation

public struct Card : Codable, Sendable, Hashable {
    public let cardNumber: String
    public let cardType: String
    
    public init(cardNumber: String, cardType: String) {
        self.cardNumber = cardNumber
        self.cardType = cardType
    }
}
