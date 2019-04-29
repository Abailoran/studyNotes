//
//  CoreDataService.swift
//  StudyNotes
//
//  Created by Abailoran on 2/27/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import Foundation
import CoreData

class CoreDataService {
    // The Class for working with Core Data library
    // MARK: - Core Data Stack
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StudyNotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    static var context = CoreDataService.persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
