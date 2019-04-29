//
//  MenuAutoLayout.swift
//  StudyNotes
//
//  Created by Abailoran on 3/31/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import UIKit

class MenuAutoLayout {
    // MARK:- Properties
    weak var view: UIView!
    weak var favoritesBtn: UIButton!
    weak var addBtn: UIButton!
    weak var tableView: UITableView!
    weak var background: UIImageView!
    private var innerViews = [UIView]()
    
    
    // MARK:- Initialization
    required init(view: UIView, favoritesBtn: UIButton, addBtn: UIButton, tableView: UITableView, background: UIImageView) {
        self.view = view
        self.favoritesBtn = favoritesBtn
        self.addBtn = addBtn
        self.tableView = tableView
        self.background = background
        
        addViewsToInnerViewsArray()
        addInnerViewsToTheViewAndAutoresizingFalse()
        setButtonsSize()
        activateConstraints()
    }
    
    
    // MARK:- Layout
    private func addViewsToInnerViewsArray() {
        innerViews.append(favoritesBtn)
        innerViews.append(addBtn)
        innerViews.append(tableView)
        innerViews.append(background)
    }
    
    private func addInnerViewsToTheViewAndAutoresizingFalse() {
        for innerView in innerViews {
            view.addSubview(innerView)
            innerView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setButtonsSize() {
        let constant = view.frame.width * 0.35
        self.addBtn.frame.size = CGSize(width: constant, height: constant)
        self.favoritesBtn.frame.size = CGSize(width: constant, height: constant)
    }
    
    
    // MARK: Constraints
    func activateConstraints() {
        NSLayoutConstraint.activate([
            favoritesBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favoritesBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            
            addBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: addBtn.bottomAnchor, constant: 16),
            
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            background.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
}
