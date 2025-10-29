//
//  File.swift
//  BluProjectModel
//
//  Created by Amir Hossein on 28/10/2025.
//

import Foundation

public protocol URLBuilderProtocol {
    func getURL(with endpoint: Endpoints) throws -> URL
}
