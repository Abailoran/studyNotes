//
//  ContainerAutoLayout.swift
//  StudyNotes
//
//  Created by Abailoran on 3/31/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import UIKit

class ContainerAutoLayout {
    // MARK:- Properties
    private weak var bgView: UIView!
    private weak var mainView: UIView!
    private weak var menu: UIView!
    private var innerViews = [UIView]()
    private var toggleConstraints = [NSLayoutConstraint]()
    private var menuWidth: CGFloat = 0.0
    
    
    // MARK:- Initialization
    init(bgView: UIView, mainView: UIView, menu: UIView, isOpen: Bool) {
        self.bgView = bgView
        self.mainView = mainView
        self.menu = menu
        menuWidth = mainView.frame.width * 0.5
        
        addViewsToInnerViewsArray()
        addInnerViewsToTheViewAndAutoresizingFalse()
        activateMainConstraints() 
        activateConstraintsBasedOnState(isOpen: isOpen)
    }
    
    
    // MARK:- Layout
    private func addViewsToInnerViewsArray() {
        innerViews.append(mainView)
        innerViews.append(menu)
    }
    
    private func addInnerViewsToTheViewAndAutoresizingFalse() {
        for innerView in innerViews {
            bgView.addSubview(innerView)
            innerView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    
    // MARK:- Constraints
    private func activateMainConstraints() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: bgView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor),
            mainView.widthAnchor.constraint(equalTo: bgView.widthAnchor),
            menu.topAnchor.constraint(equalTo: bgView.topAnchor),
            menu.bottomAnchor.constraint(equalTo: bgView.bottomAnchor),
            menu.widthAnchor.constraint(equalToConstant: menuWidth)
        ])
    }
    
    func activateConstraintsBasedOnState(isOpen: Bool) {
        // Because there are two stages of menu: open and closed, we need different constraints for each stage
        menuWidth = bgView.frame.width * 0.5
        if isOpen {
            initOpenConstraints()
        } else {
            initClosedConstraints()
        }
        NSLayoutConstraint.activate(toggleConstraints)
    }
    
    private func initOpenConstraints() {
        toggleConstraints = [
            menu.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            mainView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: menuWidth)
        ]
    }
    
    private func initClosedConstraints() {
        toggleConstraints = [
            mainView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            menu.trailingAnchor.constraint(equalTo: bgView.leadingAnchor),
        ]
    }
    
    func deactivateToggleConstraints() {
        NSLayoutConstraint.deactivate(toggleConstraints)
    }
}
