//
//  NoteConfigurator.swift
//  StudyNotes
//
//  Created by Abailoran on 3/30/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import Foundation

protocol NoteConfiguratorProtocol: class {
    func configure(with viewController: NoteViewController)
}

class NoteConfigurator: NoteConfiguratorProtocol {
    func configure(with viewController: NoteViewController) {
        let presenter = NotePresenter(view: viewController)
        let interactor = NoteInteractor(presenter: presenter)
        let router = NoteRouter(view: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
