//
//  NotesAutoLayoutManager.swift
//  StudyNotes
//
//  Created by Abailoran  on 3/30/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import UIKit

class NotesAutoLayout {
    // MARK:- Properties
    private weak var view: UIView!
    private weak var tableView : UITableView!
    private weak var menuBtn: UIButton!
    private weak var addBtn: UIButton!
    private weak var backgroundImage: UIImageView!
    private weak var searchBar: UISearchBar!
    private weak var categoryLabel: UILabel!
    private weak var deleteBtn: UIButton!
    private var innerViews = [UIView]()
    private var constraints = [NSLayoutConstraint]()
    private var constant: CGFloat = 0.0
    
    
    // MARK:- Initialization
    required init(view: UIView, tableView: UITableView, menuBtn: UIButton, addBtn: UIButton, backgroundImage: UIImageView, searchBar: UISearchBar,categoryLabel: UILabel, deleteBtn: UIButton) {
        self.view = view
        self.tableView = tableView
        self.menuBtn = menuBtn
        self.addBtn = addBtn
        self.backgroundImage = backgroundImage
        self.searchBar = searchBar
        self.categoryLabel = categoryLabel
        self.deleteBtn = deleteBtn
        
        addViewsToInnerViewsArray()
        addInnerViewsToTheViewAndAutoresizingFalse()
        setupBackgroundFrame()
        activateConstraints()
    }
    
    
    // MARK:- View
    private func addViewsToInnerViewsArray() {
        innerViews.append(tableView)
        innerViews.append(menuBtn)
        innerViews.append(addBtn)
        innerViews.append(backgroundImage)
        innerViews.append(searchBar)
        innerViews.append(categoryLabel)
        innerViews.append(deleteBtn)
    }
    
    private func addInnerViewsToTheViewAndAutoresizingFalse() {
        for innerView in innerViews {
            view.addSubview(innerView)
            innerView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupBackgroundFrame() {
        backgroundImage.frame = view.frame
    }
    
    
    // MARK: Constraints
    func activateConstraints() {
        let constant = view.frame.width * 0.5
        addBtn.frame.size = CGSize(width: constant * 0.1, height: constant * 0.1)
        menuBtn.frame.size = CGSize(width: constant * 0.1, height: constant * 0.1)
        deleteBtn.frame.size = CGSize(width: constant * 0.1, height: constant * 0.1)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: constant * 0.2),
            
            categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: (constant * 0.4)),
            categoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(constant * 0.4)),
            categoryLabel.centerYAnchor.constraint(equalTo: menuBtn.centerYAnchor),
            
            menuBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            menuBtn.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            
            addBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addBtn.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            deleteBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            deleteBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
}
