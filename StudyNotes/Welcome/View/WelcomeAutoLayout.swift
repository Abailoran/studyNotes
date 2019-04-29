//
//  WelcomeAutoLayout.swift
//  StudyNotes
//
//  Created by Abailoran on 2/27/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import UIKit

class WelcomeAutoLayout {    
    // MARK:- Properties
    weak var view: UIView!
    weak var welcomeLabel: UILabel!
    weak var appInfoLabel: UILabel!
    weak var backgroundImage: UIImageView!
    weak var okButton: UIButton!
    var innerViews = [UIView]()

    
    // MARK:- Initialization
    required init(view: UIView, welcomeLabel: UILabel, appInfoLabel: UILabel, backgroundImage: UIImageView, okButton: UIButton) {
        self.view = view
        self.welcomeLabel = welcomeLabel
        self.appInfoLabel = appInfoLabel
        self.backgroundImage = backgroundImage
        self.okButton = okButton
        
        addViewsToInnerViewsArray()
        addInnerViewsToTheViewAndAutoresizingFalse()
        setupBackgroundPosition()
        activateConstraints()
    }
    
    
    // MARK:- Layout
    private func addViewsToInnerViewsArray() {
        innerViews.append(welcomeLabel)
        innerViews.append(appInfoLabel)
        innerViews.append(backgroundImage)
        innerViews.append(okButton)
    }
    
    private func addInnerViewsToTheViewAndAutoresizingFalse() {
        for innerView in innerViews {
            view.addSubview(innerView)
            innerView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupBackgroundPosition() {
        backgroundImage.frame = view.frame
    }
    
    
    // MARK:- Constraints
    func activateConstraints() {
        let constant = view.frame.width * 0.5
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: constant * 0.25),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant * 0.1),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: (constant * 0.1)),
            
            appInfoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            appInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            appInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            okButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 16),
            okButton.widthAnchor.constraint(equalToConstant: constant),
            okButton.heightAnchor.constraint(equalToConstant: constant)
        ])
    }
}
