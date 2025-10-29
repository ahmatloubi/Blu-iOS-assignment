//
//  File.swift
//  BluProjectModel
//
//  Created by Amir Hossein on 29/10/2025.
//

import Foundation
import CoreNetwork

class ErrorDecodable: ErrorDecodableProtocol {
    private let jsonDecoder = JSONDecoder()
    
    func decodeError(_ errorData: Data) -> any Error {
        if let error = try? jsonDecoder.decode(TransferError.self, from: errorData) {
            return error
        } else {
            return TransferError.unknowError
        }
    }
}
