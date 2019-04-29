//
//  WelcomePresenter.swift
//  StudyNotes
//
//  Created by Abailoran on 2/27/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import Foundation

protocol WelcomePresenterProtocol: class {
    func setAutoAuthentication()
    func getAppInfo()
    func okBtnPressed()
}

class WelcomePresenter: WelcomePresenterProtocol {
    weak var view: WelcomeViewControllerProtocol!
    var router: WelcomeRouterProtocol!
    var interactor: WelcomeInteractorProtocol!
    
    required init(view: WelcomeViewControllerProtocol) {
        self.view = view
    }
}

extension WelcomePresenter {
    // MARK:- Protocol Methods
    func setAutoAuthentication() {
        interactor.setAutoAuthentication()
    }
    
    func getAppInfo() {
        view.appInfo = interactor.getAppInfo()
    }
    
    func okBtnPressed() {
        router.okBtnPressed()
    }
}
