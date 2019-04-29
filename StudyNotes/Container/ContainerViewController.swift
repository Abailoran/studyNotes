//
//  ContainerViewController.swift
//  StudyNotes
//
//  Created by Abailoran on 3/31/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import UIKit

protocol ContainerViewProtocol: class {
    var isOpen: Bool { get set }
    func toggleMenu()
    func updateNotes()
    func askToDeleteCurrentCategory()
}

class ContainerViewController: UIViewController, ContainerViewProtocol {
    // MARK:- Properties
    var isOpen = false
    private var notesVC: NotesViewController!
    private var menuVC: MenuViewController!
    private var autoLayout: ContainerAutoLayout!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        // We are adding notes and menu view controllers to the container
        addChild(notesVC)
        addChild(menuVC)
        configureLayout()
    }
    
    private func setupProperties() {
        notesVC = NotesViewController()
        menuVC = MenuViewController()
        menuVC.container = self
        notesVC.container = self
    }
    
    
    // MARK:- Layout
    private func configureLayout() {
        autoLayout = ContainerAutoLayout(bgView: view, mainView: notesVC.view, menu: menuVC.view, isOpen: isOpen)
    }
}

extension ContainerViewController {
    // MARK:- Protocol Methods
    // Notes and Menu Modules are communicating with each other by container: both of them have have reference to the container protocol, so they call protocol methods, when they need them 
    func toggleMenu() {
        // Animation
        autoLayout.deactivateToggleConstraints()
        view.layoutIfNeeded()
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.autoLayout.activateConstraintsBasedOnState(isOpen: self.isOpen)
                self.view.layoutIfNeeded()
        })
    }
    
    func updateNotes() {
        // This method is called by menu, when user selects any category
        notesVC.category = menuVC.selectedCategory
        notesVC.fetchData()
    }
    
    func askToDeleteCurrentCategory() {
        // This method
        menuVC.deleteCurrentCategory()
    }
}
