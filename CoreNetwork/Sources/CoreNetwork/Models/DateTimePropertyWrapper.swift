//
//  File.swift
//  CoreNetwork
//
//  Created by Amir Hossein on 29/10/2025.
//

import Foundation

@propertyWrapper
public struct DateTime: Codable, Hashable, Sendable {
    public var wrappedValue: Date?
    
    public init(wrappedValue: Date? = nil) {
        self.wrappedValue = wrappedValue
    }
    
   public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            let stringValue = try container.decode(String.self)
            
            wrappedValue = ISO8601DateFormatter().date(from: stringValue)
        } catch {
            wrappedValue = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
       var container = encoder.singleValueContainer()
       if let value = wrappedValue {
           let dateString = ISO8601DateFormatter().string(from: value)
           try container.encode(dateString)
       } else {
           try container.encodeNil()
       }
    }
}
