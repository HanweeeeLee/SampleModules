//
//  Contact+CoreDataProperties.swift
//  CoreDataSample
//
//  Created by hanwe on 2021/08/20.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var number: Int32

}

extension Contact : Identifiable {

}
