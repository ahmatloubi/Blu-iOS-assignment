//
//  File.swift
//  CoreCache
//
//  Created by Amir Hossein on 01/11/2025.
//

import Foundation
import CoreData

class PersistanceContainer {
        
    nonisolated(unsafe) public static let shared = PersistanceContainer()
    private static let modelName: String = "CoreCacheDataModel"
    
    private let container: NSPersistentContainer
    
    private let managedObjectModel: NSManagedObjectModel = {
        guard let url = Bundle.module.url(forResource: modelName, withExtension: "momd") else {
            fatalError("Failed to locate momd file for xcdatamodeld")
        }
                
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load momd file for xcdatamodeld")
        }
                
        return model
    }()
    
    public var context: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
        container = NSPersistentContainer(name: PersistanceContainer.modelName, managedObjectModel: managedObjectModel)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        })
    }
    
}
