//
//  NotesConfigurator.swift
//  StudyNotes
//
//  Created by Abailoran on 3/30/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import Foundation

protocol NotesConfiguratorProtocol : class {
    func configure(with viewController: NotesViewController)
}

class NotesConfigurator : NotesConfiguratorProtocol {
    func configure(with notesViewController: NotesViewController) {
        let presenter = NotesPresenter(view: notesViewController)
        let interactor = NotesInteractor(presenter: presenter)
        let router = NotesRouter(view: notesViewController)
            
        notesViewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }    
}
