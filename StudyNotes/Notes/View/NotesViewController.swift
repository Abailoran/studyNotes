//
//  NotesViewController.swift
//  StudyNotes
//
//  Created by Abailoran  on 3/30/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import UIKit

protocol NotesViewProtocol : class {
    var category: Category! { get set }
    var notes: [Note] { get set }
    var query: String { get set }
    func fetchData()
}

class NotesViewController: UIViewController, NotesViewProtocol {
    // MARK:- Properties
    var category: Category!
    var notes = [Note]()
    var presenter: NotesPresenterProtocol!
    var query = ""
    weak var container: ContainerViewProtocol!
    var noteViewDelegate: NoteViewControllerProtocol!
    private lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    private lazy var menuButton: UIButton = {
        let btn = UIButton()
        let image = UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal)
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(menuBtnPressed), for: .touchUpInside)
        return btn
    }()
    private lazy var addButton: UIButton = {
        let btn = UIButton()
        let image = UIImage(named: "add")?.withRenderingMode(.alwaysOriginal)
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(addBtnTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "background")
        iv.layer.zPosition = -1
        return iv
    }()
    private lazy var categoryLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Baskerville-SemiBold", size: 28)
        lbl.textAlignment = .center
        return lbl
    }()
    private lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "trash"), for: .normal)
        btn.addTarget(self, action: #selector(deleteBtnPressed), for: .touchUpInside)
        return btn
    }()
    private lazy var mainSearch: UISearchBar = {
        let sb = UISearchBar()
        sb.barTintColor = UIColor.clear
        sb.backgroundColor = UIColor.clear
        sb.isTranslucent = true
        sb.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        sb.delegate = self
        return sb
    }()
    private var autoLayout: NotesAutoLayout!
    private let configurator: NotesConfiguratorProtocol = NotesConfigurator()
    
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        configureLayout()
        presenter.saveBookmarksEntity()
        initMoveToLeftGesture()
        initMoveToRightGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if category == nil {
            presenter.openFavorites()
        }
        fetchData()
    }
    
    
    // MARK:- View & Layout
    private func configureLayout() {
        autoLayout = NotesAutoLayout(view: self.view, tableView: tableView, menuBtn: menuButton, addBtn: addButton, backgroundImage: bgImageView, searchBar: mainSearch, categoryLabel: categoryLabel, deleteBtn: deleteBtn)
    }
    
    private func setupCategoryLabelAndDeleteBtnAccess() {
        categoryLabel.text = category.name
        if category.name == "Bookmarks" {
            deleteBtn.isEnabled = false
        } else {
            deleteBtn.isEnabled = true
        }
    }
    
    
    // MARK:- Gestures
    private func initMoveToLeftGesture() {
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        gestureRecognizer.direction = .left
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    private func initMoveToRightGesture() {
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        gestureRecognizer.direction = .right
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    
    // MARK:- Actions
    @objc private func addBtnTapped() {
        presenter.addNote()
    }
    
    @objc private func menuBtnPressed() {
        container.isOpen = !container.isOpen
        container.toggleMenu()
    }
    
    @objc private func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .left {
            container.isOpen = false
        } else {
            container.isOpen = true
        }
        container.toggleMenu()
    }
    
    @objc private func deleteBtnPressed() {
        container.askToDeleteCurrentCategory()
    }
}

extension NotesViewController {
    // MARK:- Protocol Methods
    func fetchData() {
        // Method called by container, when the menu's current category is changed
        presenter.getNotes()
        setupCategoryLabelAndDeleteBtnAccess()
        self.tableView.reloadData()
    }
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK:- UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.075
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = .clear
        cell.textLabel!.font = UIFont(name: "Baskerville-BoldItalic", size: 18)
        cell.textLabel!.text = notes[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.isSelected = false
        presenter.cellSelected(with: indexPath.row)
    }
}

extension NotesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Searching
        if searchBar.text == nil || searchText.isEmpty {
            view.endEditing(true)
        }
        query = searchText
        fetchData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
