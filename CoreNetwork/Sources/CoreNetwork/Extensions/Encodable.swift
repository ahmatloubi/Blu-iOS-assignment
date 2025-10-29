//
//  File.swift
//  CoreNetwork
//
//  Created by Amir Hossein on 27/10/2025.
//

import Foundation

extension Encodable {
    var toDictionary: [String: any Any & Sendable]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: any Any & Sendable] }
    }
}
