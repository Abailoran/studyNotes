//
//  MenuInteractor.swift
//  StudyNotes
//
//  Created by Abailoran on 4/1/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import Foundation
import CoreData

protocol MenuInteractorProtocol: class {
    var enteredName: String { get set }
    var categories: [Category] { get set }
    
    func getBookmarksCategory() -> Category
    func fetchCategories()
    func addNewCategory()
    func delete(category: Category)
}

class MenuInteractor: MenuInteractorProtocol {
    weak var presenter: MenuPresenterProtocol!
    var enteredName = ""
    var categories = [Category]()
    private var checkName = ""
    
    required init(presenter: MenuPresenterProtocol) {
        self.presenter = presenter
    }
}

extension MenuInteractor {
    // MARK:- Protocol Methods
    func fetchCategories() {
        resetArray()
        performFetch()
    }
    
    private func resetArray() {
        categories = []
    }
    
    private func performFetch() {
        // Get from the persistent container all categories, except bookmarks, because we do not want it to show up in categories' names list
        let request = Category.fetchRequest() as NSFetchRequest<Category>
        request.predicate = NSPredicate(format: "name != %@", "Bookmarks")
        do {
            categories = try CoreDataService.context.fetch(request)
        } catch let error as NSError {
            print("unresolved error: \(error)")
        }
    }
    
    func getBookmarksCategory() -> Category {
        // Get bookmarks category from all categories
        var bookmarks: Category?
        let request = Category.fetchRequest() as NSFetchRequest<Category>
        request.predicate = NSPredicate(format: "name == %@", "Bookmarks")
        do {
            bookmarks = try CoreDataService.context.fetch(request)[0]
        } catch {
            presenter.reportError()
        }
        return bookmarks!
    }
    
    func addNewCategory() {
        modifyEnteredString()
        if check() {
            initNewCategory()
            CoreDataService.saveContext()
        } else {
            presenter.reportError()
        }
    }
    
    private func modifyEnteredString() {
        // modifying string for futher data check
        checkName = enteredName.lowercased().trimmingCharacters(in: .whitespaces)
    }
    
    private func check() -> Bool {
        // Data check
        var isAppropriate = true
        for category in categories {
            if checkName == category.name?.lowercased() {
                isAppropriate = false
            }
        }
        if checkName == "Bookmarks" {
            isAppropriate = false
        }
        if checkName == "" {
            isAppropriate = false
        }
        return isAppropriate
    }
    
    private func initNewCategory() {
        let category = Category(context: CoreDataService.context)
        category.name = enteredName
        category.notes = []
    }
    
    func delete(category: Category) {
        CoreDataService.context.delete(category)
        CoreDataService.saveContext()
    }
}
