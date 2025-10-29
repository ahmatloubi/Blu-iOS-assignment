//
//  File.swift
//  CoreNetwork
//
//  Created by Amir Hossein on 28/10/2025.
//

import Foundation

public protocol ErrorDecodableProtocol {
    func decodeError(_ errorData: Data) -> Error
}
