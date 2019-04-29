//
//  MenuConfigurator.swift
//  StudyNotes
//
//  Created by Abailoran on 4/1/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import Foundation

protocol MenuConfiguratorProtocol: class {
    func configure(with viewController: MenuViewController)
}

class MenuConfigurator: MenuConfiguratorProtocol{
    func configure(with viewController: MenuViewController) {
        let presenter = MenuPresenter(view: viewController)
        let interactor = MenuInteractor(presenter: presenter)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
    }
}

