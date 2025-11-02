//
//  File.swift
//  CoreCache
//
//  Created by Amir Hossein on 01/11/2025.
//

import Foundation

public protocol CacherProtocol {
    func addOrUpdate<T: Codable>(value: T, primaryKey: String) throws
    func fetch<T: Codable>(primaryKey: String) throws -> T?
    func fetchList<T: Codable>(primaryKey: String) throws -> [T]
    func delete(primaryKey: String) throws
}
