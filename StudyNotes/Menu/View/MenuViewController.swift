//
//  MenuViewController.swift
//  StudyNotes
//
//  Created by Abailoran on 3/31/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import UIKit

protocol MenuViewProtocol: class {
    var selectedCategory: Category! { get set }
    var categories: [Category] { get set }
    
    func updateOwnContent()
    func sendRequestToContainer()
    func showErrorAlert()
    func deleteCurrentCategory()
}

class MenuViewController: UIViewController, MenuViewProtocol {
    // MARK: Properties
    var selectedCategory: Category!
    var categories = [Category]()
    var presenter: MenuPresenterProtocol!
    weak var container: ContainerViewProtocol!
    private lazy var addBtn: UIButton = {
        let btn = UIButton()
        let image = UIImage(named: "add")
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(plusBtnTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var bookmarkBtn: UIButton = {
        let btn = UIButton()
        let image = UIImage(named: "bookmark")
        btn.addTarget(self, action: #selector(bookmarkBtnTapped), for: .touchUpInside)
        btn.setImage(image, for: .normal)
        return btn
    }()
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorColor = .clear
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    private lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.zPosition = -1
        iv.image = UIImage(named: "background")
        return iv
    }()
    private var autoLayout: MenuAutoLayout!
    private let configurator: MenuConfiguratorProtocol = MenuConfigurator()
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        configureLayout()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // we are calling presenter's methods to get the content
        presenter.fetchCategories()
    }
    
    // MARK:- View & Layout
    private func configureLayout() {
        autoLayout = MenuAutoLayout(view: self.view, favoritesBtn: bookmarkBtn, addBtn: addBtn, tableView: tableView, background: backgroundImageView)
    }
    
    
    // MARK: Actions
    @objc private func plusBtnTapped() {
        let alert = initAlertController()
        self.show(alert, sender: nil)
    }

    private func initAlertController() -> UIAlertController {
        // The 'A new category' alert
        let alert = UIAlertController(title: "A new Category", message: "Add a new section of your notes", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.actionHandler(alert: alert)
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Category name"
        })
        alert.addAction(action)
        return alert
    }
    
    private func actionHandler(alert: UIAlertController) {
        // checking data and sending request to the presenter
        guard let text = alert.textFields?[0].text else { return }
        self.presenter.plusBtnTapped(with: text)
        self.tableView.reloadData()
    }

    @objc private func bookmarkBtnTapped() {
        presenter.openFavorites()
    }
}

extension MenuViewController {
    // MARK:- Protocol Methods
    // Presenter calls view's methods depending on the situation
    func updateOwnContent() {
        // this method is called by presenter, content updates
        presenter.fetchCategories()
        self.tableView.reloadData()
    }
    
    func sendRequestToContainer() {
        // this method is called by presenter, when user touches any category
        container.updateNotes()
    }
    
    func showErrorAlert() {
        // this method is called when entered data is incorrect
        let alert = UIAlertController(title: "Incorrect Data", message: "Write your custom category name again please", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        self.show(alert, sender: nil)
    }
    
    func deleteCurrentCategory() {
        // this method is called by container when the notes' delete button is pressed
        let alert = UIAlertController(title: "Delete the category", message: "Are you sure you want to delete the category?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.presenter.deleteCategory()
            self.updateOwnContent()
            self.presenter.openFavorites()
        })
        alert.addAction(action)
        self.show(alert, sender: nil)
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK:- UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configurating cell
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = .clear
        cell.textLabel!.font = UIFont(name: "Baskerville-SemiBold", size: 18)
        cell.textLabel!.text = categories[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Action to happen when cell is selected 
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        presenter.categoryCellTapped(with: indexPath.row)
    }
}
