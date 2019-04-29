//
//  ViewController.swift
//  StudyNotes
//
//  Created by Abailoran on 2/27/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import UIKit

protocol WelcomeViewControllerProtocol: class {
    var appInfo: String { get set }
}

class WelcomeViewController: UIViewController, WelcomeViewControllerProtocol {
    // MARK:- Properties
    var appInfo = "" {
        didSet {
            appInfoLabel.text = appInfo
        }
    }
    var presenter: WelcomePresenterProtocol!
    let configurator: WelcomeConfiguratorProtocol = WelcomeConfigurator()
    private lazy var welcomeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Welcome to the 'StudyNotes' app!"
        lbl.numberOfLines = 2
        lbl.font = UIFont(name: "Helvetica-Bold", size: 34)
        return lbl
    }()
    private lazy var appInfoLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 3
        lbl.font = UIFont(name: "Helvetica", size: 20)
        return lbl
    }()
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "background")
        image.contentMode = .scaleAspectFill
        image.layer.zPosition = -1
        return image
    }()
    private lazy var okButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ok"), for: .normal)
        btn.addTarget(self, action: #selector(okButtonPressed), for: .touchUpInside)
        return btn
    }()
    private var autoLayout: WelcomeAutoLayout!
    
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.setAutoAuthentication()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getAppInfo()
    }
    
    
    // MARK:- Layout
    private func configureLayout() {
        autoLayout = WelcomeAutoLayout(view: self.view, welcomeLabel: welcomeLabel, appInfoLabel: appInfoLabel, backgroundImage: backgroundImage, okButton: okButton)
    }
    
    // MARK:- Actions
    @objc private func okButtonPressed() {
        presenter.okBtnPressed()
    }
}

