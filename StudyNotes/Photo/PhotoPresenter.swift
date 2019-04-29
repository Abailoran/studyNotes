//
//  PhotoPresenter.swift
//  StudyNotes
//
//  Created by Abailoran on 4/19/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import Foundation

protocol PhotoPresenterProtocol: class {
    func closeView()
}

class PhotoPresenter: PhotoPresenterProtocol {
    weak var view: PhotoViewProtocol!
    var router: PhotoRouterProtocol!
    
    required init(view: PhotoViewProtocol) {
        self.view = view
    }
}

extension PhotoPresenter {
    func closeView() {
        router.close()
    }
}
