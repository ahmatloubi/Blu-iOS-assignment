//
//  Person.swift
//  BluProjectModel
//
//  Created by Amir Hossein on 27/10/2025.
//

import Foundation

public struct Person: Codable, Sendable, Hashable {
    public let fullName: String
    public let email: String?
    public let avatar: String?
    
    public init(name: String, email: String? = nil, avatar: String? = nil) {
        self.fullName = name
        self.email = email
        self.avatar = avatar
    }
}
