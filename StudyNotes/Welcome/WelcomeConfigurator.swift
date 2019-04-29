//
//  WelcomeConfigurator.swift
//  StudyNotes
//
//  Created by Abailoran on 2/27/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import Foundation

protocol WelcomeConfiguratorProtocol: class {
    func configure(with viewController: WelcomeViewController)
}

class WelcomeConfigurator: WelcomeConfiguratorProtocol {
    // Bind all components with each other
    func configure(with viewController: WelcomeViewController) {
        let presenter = WelcomePresenter(view: viewController)
        let interactor = WelcomeInteractor(presenter: presenter)
        let router = WelcomeRouter(view: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
