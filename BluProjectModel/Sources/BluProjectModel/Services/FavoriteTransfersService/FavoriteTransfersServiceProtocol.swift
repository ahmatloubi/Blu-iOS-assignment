//
//  File.swift
//  BluProjectModel
//
//  Created by Amir Hossein on 01/11/2025.
//

import Foundation

public protocol FavoriteTransfersServiceProtocol {
    func getFavoriteTransfers() throws -> [Transfer]
    func addFavoriteTransfer(_ transfer: Transfer) throws
    func removeFavoriteTransfer(_ transfer: Transfer) throws
}
