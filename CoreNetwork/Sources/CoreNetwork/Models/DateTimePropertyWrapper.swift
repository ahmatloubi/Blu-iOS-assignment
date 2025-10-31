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
            wrappedValue = DateTimeFormatter.formatter.date(from: stringValue)
        } catch {
            wrappedValue = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
       var container = encoder.singleValueContainer()
       if let value = wrappedValue {
           let dateString = DateTimeFormatter.formatter.string(from: value)
           try container.encode(dateString)
       } else {
           try container.encodeNil()
       }
    }
}

struct DateTimeFormatter {
    static let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.isLenient = true
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(abbreviation: "IRST")!
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter
    }()
}
