//
//  NotesPresenter.swift
//  StudyNotes
//
//  Created by Abailoran on 3/30/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import Foundation

protocol NotesPresenterProtocol : class {
    func saveBookmarksEntity()
    func openFavorites()
    func getNotes()
    func addNote()
    func cellSelected(with index: Int)
}

class NotesPresenter: NotesPresenterProtocol {
    weak var view: NotesViewProtocol!
    var router: NotesRouterProtocol!
    var interactor: NotesInteractorProtocol!
    
    required init(view: NotesViewProtocol) {
        self.view = view
    }
}

extension NotesPresenter {
    // MARK: Protocol Methods
    func saveBookmarksEntity() {
        interactor.saveBookmarksInMemory()
    }
    
    func openFavorites() {
        view.category = interactor.openFavorites()
    }
    
    func getNotes() {
        // Because sometimes
        interactor.category = view.category
        router.category = view.category
        // query - is the search text, by default it's empty
        interactor.getSavedNotes(query: view.query)
        // once we got saved notes, we assign view's notes to interactor's notes
        view.notes = interactor.notes
    }
    
    func addNote() {
        router.addNote()
    }
    
    func cellSelected(with index: Int) {
        let note = interactor.notes[index]
        router.didSelectCell(pass: note)
    }
}
