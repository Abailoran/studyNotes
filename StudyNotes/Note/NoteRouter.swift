//
//  NoteRouter.swift
//  StudyNotes
//
//  Created by Abailoran on 3/30/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import Foundation

protocol NoteRouterProtocol: class {
    func close(loadingIsNeeded: Bool)
    func showImages()
}

class NoteRouter: NoteRouterProtocol{
    weak var view: NoteViewController!
    
    required init(view: NoteViewController) {
        self.view = view
    }
}

extension NoteRouter {
    func close(loadingIsNeeded: Bool) {
        view.notes.category = view.category
        if loadingIsNeeded {
            LoadingView.loadingAlert(view: self.view)
            view.notes.fetchData()
            LoadingView.dismissAlert {
                self.view.dismiss(animated: true, completion: nil)
            }
        } else {
            self.view.dismiss(animated: true, completion: nil)
        }
    }
    
    func showImages() {
        let vc = PhotoViewController()
        view.imagesViewDelegate = vc
        view.imagesViewDelegate.images = view.images
        view.show(vc, sender: nil)
    }
}
