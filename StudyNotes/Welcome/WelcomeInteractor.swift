//
//  WelcomeInteractor.swift
//  StudyNotes
//
//  Created by Abailoran on 2/27/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import Foundation

protocol WelcomeInteractorProtocol: class {
    func getAppInfo() -> String
    func setAutoAuthentication()
}

class WelcomeInteractor: WelcomeInteractorProtocol {
    weak var presenter: WelcomePresenterProtocol!
    
    required init(presenter: WelcomePresenterProtocol) {
        self.presenter = presenter
    }
}

extension WelcomeInteractor {
    // MARK:- Protocol Methods
    func getAppInfo() -> String {
        return WelcomeSDA.appInfo
    }
    
    func setAutoAuthentication() {
        UserDefaults.standard.set(1, forKey: "isTheFirstTime")
    }
}
