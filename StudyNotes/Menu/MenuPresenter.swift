//
//  MenuPresenter.swift
//  StudyNotes
//
//  Created by Abailoran on 4/1/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import Foundation

protocol MenuPresenterProtocol: class {
    func fetchCategories()
    func openFavorites()
    func plusBtnTapped(with name: String)
    func categoryCellTapped(with index: Int)
    func reportError()
    func deleteCategory()
}

class MenuPresenter: MenuPresenterProtocol {
    weak var view: MenuViewProtocol!
    var interactor: MenuInteractorProtocol!
    
    required init(view: MenuViewProtocol) {
        self.view = view
    }
}

extension MenuPresenter {
    // MARK:- Protocol Methods
    func fetchCategories() {
        // Get content from interactor, which works with Core Data Service
        interactor.fetchCategories()
        view.categories = interactor.categories
    }
    
    func openFavorites() {
        // This method is called when the bookmarks button is pressed, it's changing notes' current category
        view.selectedCategory = interactor.getBookmarksCategory()
        view.sendRequestToContainer()
    }
    
    func plusBtnTapped(with name: String) {
        // create a new category
        interactor.enteredName = name
        interactor.addNewCategory()
        view.updateOwnContent()
    }
    
    func categoryCellTapped(with index: Int) {
        // update menu's and notes' current category
        view.selectedCategory = interactor.categories[index]
        view.sendRequestToContainer()
    }
    
    func reportError() {
        view.showErrorAlert()
    }
    
    func deleteCategory() {
        interactor.delete(category: view.selectedCategory)
    }
}
