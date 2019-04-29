//
//  Image+CoreDataProperties.swift
//  StudyNotes
//
//  Created by Abailoran on 4/28/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//
//

import Foundation
import CoreData


extension Image {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var data: NSData?
    @NSManaged public var note: Note?
}
