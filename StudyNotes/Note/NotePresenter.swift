//
//  NotePresenter.swift
//  StudyNotes
//
//  Created by Abailoran on 3/30/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import UIKit

protocol NotePresenterProtocol: class {
    func configureViewContent()
    func close()
    func addToFavorites()
    func showNotifyAlert()
    func share()
    func deleteNote()
    func showImagesDetail()
    func editNote()
    func saveChanges()
    func titleChoosedSuccessfully()
}

class NotePresenter: NotePresenterProtocol {
    // MARK:- Properties
    weak var view: NoteViewControllerProtocol!
    var router: NoteRouterProtocol!
    var interactor: NoteInteractorProtocol!
    
    required init(view: NoteViewControllerProtocol) {
        self.view = view
    }
}

extension NotePresenter {
    // MARK:- Protocol Methods
    func configureViewContent() {
        if view.note != nil {
            interactor.note = view.note
            interactor.getContent()
            self.setupViewProperties()
        }
        view.varyContent(isEditing: (view.mode == .edit))
    }
    
    private func setupViewProperties() {
        view.noteTitle = interactor.title
        view.text = interactor.text
        view.images = interactor.images
    }
    
    
    // MARK:- Detail Mode Functionality
    func close() {
        router.close(loadingIsNeeded: false)
    }
    
    func share() {
        view.showActivityVC(with: interactor.getItemsToShare())
    }
    
    func addToFavorites() {
        interactor.addToFavorites()
        router.close(loadingIsNeeded: true)
    }
    
    func showNotifyAlert() {
        view.showNotifyAlert()
    }
    
    func deleteNote() {
        interactor.delete()
        router.close(loadingIsNeeded: true)
    }
    
    func showImagesDetail() {
        router.showImages()
    }
    
    func editNote() {
        view.turnOnEditMode()
        view.varyContent(isEditing: true)
    }
    
    
    // MARK:- Edit Mode Functionality
    func saveChanges() {
        view.showSaveNoteAlert()
    }
    
    func titleChoosedSuccessfully() {
        // the method, which is called if view's showSaveNoteAlert() happened successfully
        view.updateText()
        updateProperties()
        interactor.save(in: view.category!)
        router.close(loadingIsNeeded: true)
    }
    
    private func updateProperties() {
        interactor.title = view.noteTitle
        interactor.text = view.text
        interactor.images = view.images
    }
}
