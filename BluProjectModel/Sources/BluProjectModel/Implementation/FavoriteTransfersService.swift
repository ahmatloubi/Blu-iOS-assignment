//
//  File.swift
//  BluProjectModel
//
//  Created by Amir Hossein on 01/11/2025.
//

import Foundation
import CoreCache

public class FavoriteTransfersService: FavoriteTransfersServiceProtocol {
    
    
    private let cacher: CacherProtocol
    
    public init(cacher: CacherProtocol) {
        self.cacher = cacher
    }

    public func addFavoriteTransfer(_ transfer: Transfer) throws {
        var favoriteTransfers = try getFavoriteTransfers()
        favoriteTransfers.append(transfer)
        try cacher.addOrUpdate(value: favoriteTransfers, primaryKey: CacheKeys.favoriteTransfer.rawValue)
    }
    
    public func getFavoriteTransfers() throws -> [Transfer] {
        return try cacher.fetchList(primaryKey: CacheKeys.favoriteTransfer.rawValue)
    }
    
    public func removeFavoriteTransfer(_ transfer: Transfer) throws {
        var favoriteTransfers = try getFavoriteTransfers()
        favoriteTransfers.removeAll(where: { $0.id == transfer.id })
        try cacher.addOrUpdate(value: favoriteTransfers, primaryKey: CacheKeys.favoriteTransfer.rawValue)
    }
}
