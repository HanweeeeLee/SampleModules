//
//  PersistenceManagerProtocol.swift
//  CoreDataSample
//
//  Created by hanwe on 2021/08/20.
//

import UIKit
import CoreData

protocol PersistenceManagerProtocol {
    associatedtype PersistenceManagerClassType: PersistenceManagerProtocol
    associatedtype insertedObject
    
    static var shared: PersistenceManagerClassType { get set }
    var persistentContainer: NSPersistentContainer { get set }
    var context: NSManagedObjectContext { get }
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]
    @discardableResult func insert(insertedObject: insertedObject) -> Bool
    @discardableResult func delete(object: NSManagedObject) -> Bool
    @discardableResult func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool
    func count<T: NSManagedObject>(request: NSFetchRequest<T>) -> Int?
}
