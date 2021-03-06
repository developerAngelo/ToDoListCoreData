//
//  ToDoList+CoreDataProperties.swift
//  ToDoListCoreData
//
//  Created by Ruthlyn Huet on 2/26/21.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?

}

extension ToDoList : Identifiable {

}
