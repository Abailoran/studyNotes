//
//  NotesInteractor.swift
//  StudyNotes
//
//  Created by Abailoran on 3/30/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import Foundation
import CoreData

protocol NotesInteractorProtocol : class {
    var category: Category! { get set }
    var notes: [Note] { get set }
    
    func saveBookmarksInMemory()
    func openFavorites() -> Category
    func getSavedNotes(query: String)
}

class NotesInteractor: NotesInteractorProtocol {
    var category: Category!
    var notes = [Note]()
    weak var presenter: NotesPresenterProtocol!
    
    required init(presenter: NotesPresenterProtocol) {
        self.presenter = presenter
    }
}

extension NotesInteractor {
    // MARK: Protocol Methods
    func saveBookmarksInMemory() {
        // Because there are no categories by default, we are initializating bookmarks in memory manually, but we don't want to full the memory with bookmarks every time, so we are firstly checking, wasn't it initializated before
        if UserDefaults.standard.value(forKey: "createdBookmarks") == nil {
            let bookmarks = Category(context: CoreDataService.context)
            bookmarks.name = "Bookmarks"
            bookmarks.notes = []
            UserDefaults.standard.set(1, forKey: "createdBookmarks")
        }
    }
    
    func openFavorites() -> Category {
        // get bookmarks category
        var bookmarks: Category?
        let request = Category.fetchRequest() as NSFetchRequest<Category>
        request.predicate = NSPredicate(format: "name == %@", "Bookmarks")
        do {
            bookmarks = try CoreDataService.context.fetch(request)[0]
        } catch let error as NSError {
            print("unresolved error: \(error)")
        }
        return bookmarks!
    }
    
    func getSavedNotes(query: String) {
        let request = Note.fetchRequest() as NSFetchRequest<Note>
        initPredicates(request: request, query: query)
        
        do {
            notes = try CoreDataService.context.fetch(request)
        } catch let error as NSError {
            print("unresolved error: \(error)")
        }
    }
    
    private func initPredicates(request: NSFetchRequest<Note>, query: String) {
        // We add search predicates: sorting parameters for finding notes which contain search text if needed
        let categoryPredicate = NSPredicate(format: "category == %@", category)
        if !query.isEmpty {
            let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [categoryPredicate, titlePredicate])
            request.predicate = andPredicate
        } else {
            request.predicate = categoryPredicate
        }
    }
}


