//
//  PhotoConfigurator.swift
//  StudyNotes
//
//  Created by Abailoran on 4/19/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import Foundation

protocol PhotoConfiguratorProtocol: class {
    func configure(with viewController: PhotoViewController)
}

class PhotoConfigurator: PhotoConfiguratorProtocol {
    func configure(with viewController: PhotoViewController) {
        let presenter = PhotoPresenter(view: viewController)
        let router = PhotoRouter(view: viewController)
        
        viewController.presenter = presenter
        presenter.router = router
    }
}
