//
//  Category+CoreDataProperties.swift
//  StudyNotes
//
//  Created by Abailoran on 4/28/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var notes: NSSet?
}

// MARK: Generated accessors for notes
extension Category {
    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)
}
