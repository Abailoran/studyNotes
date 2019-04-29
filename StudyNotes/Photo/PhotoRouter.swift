//
//  PhotoRouter.swift
//  StudyNotes
//
//  Created by Abailoran on 4/19/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import Foundation

protocol PhotoRouterProtocol: class {
    func close()
}


class PhotoRouter: PhotoRouterProtocol {
    weak var view: PhotoViewController!
    
    required init(view: PhotoViewController) {
        self.view = view
    }
}

extension PhotoRouter {
    // MARK:- Protocol Methods
    func close() {
        view.dismiss(animated: true, completion: nil)
    }
}
