//
//  Image+CoreDataProperties.swift
//  StudyNotes
//
//  Created by ABAI LORAN  on 4/29/19.
//  Copyright © 2019 AXware. All rights reserved.
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
