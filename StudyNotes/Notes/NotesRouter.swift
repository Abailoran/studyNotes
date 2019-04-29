//
//  NotesRouter.swift
//  StudyNotes
//
//  Created by Abailoran on 3/30/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import Foundation

protocol NotesRouterProtocol : class {
    var category: Category! { get set }
    
    func addNote()
    func didSelectCell(pass note: Note)
}

class NotesRouter : NotesRouterProtocol {
    var category: Category!
    weak var view: NotesViewController!
    private var vc: NoteViewController!
    
    required init(view: NotesViewController) {
        self.view = view
    }
}

extension NotesRouter {
    // MARK:- Protocol Methods
    // Because note module is being reused for adding and detail view, we are passing different parameters to the note, depending on mode. So here we have setupCommonProperties() and setupDetailProperties(), where first method is used by both add and edit modes, but setupDetailProperties is only for detail mode, because we pass already created note
    func addNote() {
        vc = NoteViewController()
        setupCommonProperties()
        LoadingView.loadingAlert(view: view)
        LoadingView.dismissAlert {
            self.view.show(self.vc, sender: nil)
        }
    }
    
    func didSelectCell(pass note: Note) {
        vc = NoteViewController()
        setupCommonProperties()
        setupDetailProperties(note: note)
        LoadingView.loadingAlert(view: view)
        LoadingView.dismissAlert {
            self.view.show(self.vc, sender: nil)
        }
    }
    
    // MARK:- Data Passing
    private func setupCommonProperties() {
        view.noteViewDelegate = vc
        view.noteViewDelegate.category = self.category
        view.noteViewDelegate.notes = view
    }
    
    private func setupDetailProperties(note: Note) {
        view.noteViewDelegate.mode = .detail
        view.noteViewDelegate.note = note
        view.noteViewDelegate.notes = view
    }
}

