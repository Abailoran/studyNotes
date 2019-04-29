//
//  WelcomeRouter.swift
//  StudyNotes
//
//  Created by Abailoran on 2/27/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import Foundation

protocol WelcomeRouterProtocol: class {
    func okBtnPressed()
}

class WelcomeRouter: WelcomeRouterProtocol {
    weak var view: WelcomeViewController!
    
    required init(view: WelcomeViewController) {
        self.view = view
    }
}

extension WelcomeRouter {
    func okBtnPressed() {
        let containerViewController = ContainerViewController()
        LoadingView.loadingAlert(view: view)
        LoadingView.dismissAlert {
            self.view.show(containerViewController, sender: nil)
        }
    }
}
