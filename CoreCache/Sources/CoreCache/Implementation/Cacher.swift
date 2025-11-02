//
//  File.swift
//  CoreCache
//
//  Created by Amir Hossein on 01/11/2025.
//

import Foundation
import CoreData

public final class Cacher: CacherProtocol {
    
    private let context: NSManagedObjectContext
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    public init() {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
        context = PersistanceContainer.shared.context
    }
    
    
    private func fetch(primaryKey: String) throws -> [Cache]? {
        let fetchRequest = Cache.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "primaryKey = %@", primaryKey)
        let results = try context.fetch(fetchRequest)
        return results
    }
        
    public func fetch<T: Codable>(primaryKey: String) throws -> T? {
        let fetchResult = try fetch(primaryKey: primaryKey)?.first

        if let result = fetchResult?.value {
            let decodedValue = try decoder.decode(T.self, from: result)
            return decodedValue
        }

        return nil
    }

    public func fetchList<T: Codable>(primaryKey: String) throws -> [T] {
        let fetchResult = try fetch(primaryKey: primaryKey)?.first

        guard let result = fetchResult?.value  else { return [] }
        return try decoder.decode([T].self, from: result)
    }
    
    public func addOrUpdate<T: Codable>(value: T, primaryKey: String) throws {
        if let encodedValue = try? encoder.encode(value) {
            create(value: encodedValue, primaryKey: primaryKey)
            try save()
        }
        
    }
    
    public func delete(primaryKey: String) throws {
        let entity = try fetch(primaryKey: primaryKey)?.first
        
        if let entity {
            context.delete(entity)
        }
        
        try save()
    }
    
    private func save() throws {
        try context.save()
    }

    private func create(value: Data, primaryKey: String) {
        guard let entity = try? fetch(primaryKey: primaryKey)?.first else {
            let newEntity = Cache(context: context)
            newEntity.primaryKey = primaryKey
            newEntity.value = value
            return
        }
        entity.primaryKey = primaryKey
        entity.value = value
    }
    
}
