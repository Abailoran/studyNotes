//
//  NoteInteractor.swift
//  StudyNotes
//
//  Created by Abailoran on 3/30/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import UIKit
import CoreData

protocol NoteInteractorProtocol: class {
    var note: Note? { get set }
    var title: String { get set }
    var text: String { get set }
    var images: [UIImage] { get set }
    
    func getContent()
    func getItemsToShare() -> [Any]
    func delete()
    func addToFavorites()
    func save(in category: Category)
}

class NoteInteractor: NoteInteractorProtocol {
    weak var presenter: NotePresenterProtocol!
    var note: Note?
    var title = ""
    var text = ""
    var images = [UIImage]()
    
    required init(presenter: NotePresenterProtocol) {
        self.presenter = presenter
    }
}

extension NoteInteractor {
    // MARK:- Protocol Methods
    func getContent() {
        // get content from the existing note
        self.title = note!.title!
        self.text = note!.text!
        images = []
        for image in note!.images! {
            let data = image as? Image
            images.append(UIImage(data: data!.data! as Data)!)
        }
    }
    
    
    // MARK:- Detail Mode Functionality
    func getItemsToShare() -> [Any] {
        return images + [title, text]
    }
    
    func delete() {
        CoreDataService.context.delete(note!)
        CoreDataService.saveContext()
    }
    
    func addToFavorites() {
        // several methods, which add note to the bookmarks category
        let bookmarks = getBookmarksCategory()
        if isNameRepeating(bookmarks: bookmarks.notes as! Set<Note>) {
            presenter.showNotifyAlert()
            return
        }
        copyNote(bookmarks: bookmarks)
        CoreDataService.saveContext()
    }
    
    private func getBookmarksCategory() -> Category {
        // fetch the bookmarks category
        var bookmarks: Category?
        let request = Category.fetchRequest() as NSFetchRequest<Category>
        request.predicate = NSPredicate(format: "name == %@", "Bookmarks")
        do {
            bookmarks = try CoreDataService.context.fetch(request)[0]
        } catch {
            bookmarks = nil
        }
        return bookmarks!
    }
    
    private func isNameRepeating(bookmarks: Set<Note>) -> Bool {
        // checking data...
        for bookmark in bookmarks {
            if (note!.title == bookmark.title) {
                return true
            }
        }
        return false
    }
    
    private func copyNote(bookmarks: Category) {
        // copying the existing note, to duplicate it to the bookmarks
        let secondNote = Note(context: CoreDataService.context)
        secondNote.images = note?.images
        secondNote.title = note?.title
        secondNote.text = note?.text
        secondNote.category = bookmarks
    }
    
    
    // MARK:- Add Mode Functionality
    func save(in category: Category) {
        // if note already existed, it means it was editing mode
        if note != nil {
            setupProperties(aNote: note!)
        } else {
            initNewNote(category: category)
        }
        CoreDataService.saveContext()
    }
    
    private func initNewNote(category: Category) {
        let newNote = Note(context: CoreDataService.context)
        setupProperties(aNote: newNote)
        newNote.category = category
    }
    
    private func setupProperties(aNote: Note) {
        aNote.title = title
        aNote.text = text
        for image in images {
            initImageEntity(image: image, aNote: aNote)
        }
    }
    
    private func initImageEntity(image: UIImage, aNote: Note) {
        let imageEntity = Image(context: CoreDataService.context)
        imageEntity.data = image.pngData() as NSData?
        imageEntity.note = aNote
    }
}
