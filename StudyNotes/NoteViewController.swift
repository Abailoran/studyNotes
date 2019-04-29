//
//  NoteViewController.swift
//  StudyNotes
//
//  Created by Abailoran on 3/30/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import UIKit

enum NoteMode {
    case detail
    case edit
}

protocol NoteViewControllerProtocol: class {
    var notes: NotesViewProtocol! { get set }
    var category: Category! { get set }
    var note: Note? { get set }
    var mode: NoteMode { get set }
    var noteTitle: String { get set }
    var text: String { get set }
    var images: [UIImage] { get set }
    
    func varyContent(isEditing: Bool)
    func updateText() 
    func turnOnEditMode()
    func showActivityVC(with items: [Any])
    func showNotifyAlert()
    func showSaveNoteAlert()
}

class NoteViewController: UIViewController, NoteViewControllerProtocol {
    //MARK: - Properties
    weak var notes: NotesViewProtocol!
    var presenter: NotePresenterProtocol!
    var category: Category!
    var note: Note? 
    var mode: NoteMode = .edit
    var noteTitle = "" {
        didSet {
            titleLabel.text = noteTitle
        }
    }
    var text = "" {
        didSet {
            noteTextView.text = text
        }
    }
    var images = [UIImage]()
    var imagesViewDelegate: PhotoViewProtocol!
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    let imagePicker = UIImagePickerController()
    var pageControl = UIPageControl(frame: CGRect(x: 50, y: 300, width: 200, height: 20))
    private lazy var titleLabel: UILabel = {
        var lbl = UILabel()
        lbl.textColor = UIColor.black
        lbl.font = UIFont(name: "Baskerville-SemiBold", size: 28)
        lbl.textAlignment = .left
        lbl.text = "New Note"
        return lbl
    }()
    private lazy var noteTextView: UITextView = {
        var txtV = UITextView()
        txtV.text = "Note information here..."
        txtV.font = UIFont(name: "Helvetica", size: 18)
        txtV.backgroundColor = .clear
        txtV.isEditable = false
        txtV.textColor = .gray
        txtV.delegate = self
        return txtV
    }()
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "background")
        image.contentMode = .scaleAspectFill
        image.layer.zPosition = -1
        return image
    }()
    private lazy var imagesScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        sv.isPagingEnabled = true
        return sv
    }()
    private lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setImage(UIImage(named: "save"), for: .normal)
        btn.addTarget(self, action: #selector(saveBtnPressed), for: .touchUpInside)
        return btn
    }()
    private lazy var addImageBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "add"), for: .normal)
        btn.addTarget(self, action: #selector(imagePressed), for: .touchUpInside)
        return btn
    }()
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
        return btn
    }()
    private lazy var shareBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "share"), for: .normal)
        btn.addTarget(self, action: #selector(shareBtnPressed), for: .touchUpInside)
        return btn
    }()
    private lazy var bookmarkBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "bookmark"), for: .normal)
        btn.addTarget(self, action: #selector(bookmarkBtnPressed), for: .touchUpInside)
        return btn
    }()
    private lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "trash"), for: .normal)
        btn.addTarget(self, action: #selector(deleteBtnPressed), for: .touchUpInside)
        return btn
    }()
    private lazy var editBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "edit"), for: .normal)
        btn.addTarget(self, action: #selector(editBtnPressed), for: .touchUpInside)
        return btn
    }()
    private lazy var detailBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "detail"), for: .normal)
        btn.addTarget(self, action: #selector(detailBtnPressed), for: .touchUpInside)
        return btn
    }()
    private let configurator: NoteConfiguratorProtocol = NoteConfigurator()
    private var autoLayout: NoteAutoLayout!
    
    
    // MARK: Initialization
    convenience init(note: Note, category: Category, mode: NoteMode) {
        self.init()
        self.note = note
        self.category = category
        self.mode = mode
    }
    
    
    // MARK:- View Lifestyle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        setupPageControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureLayout()
        presenter.configureViewContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupScrollView()
    }
    
    
    // MARK:- View & Layout
    private func configureLayout() {
        autoLayout = NoteAutoLayout(view: self.view, titleLabel: titleLabel, backgroundImage: backgroundImage, noteTextView: noteTextView, scrollView: imagesScrollView, closeBtn: closeBtn, shareBtn: shareBtn, bookmarkBtn: bookmarkBtn, deleteBtn: deleteBtn, editBtn: editBtn, saveBtn: saveBtn, addImage: addImageBtn, pageControl: pageControl, detailBtn: detailBtn)
        autoLayout.activateModeConstraints(mode: self.mode)
    }
    
    // MARK: Page Control
    private func setupPageControl() {
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .gray
    }
    
    
    // MARK: Scroll View
    private func setupScrollView() {
        addOrRemoveDefault()
        
        for index in 0..<images.count {
            setupImages(index: index)
        }
        
        pageControl.numberOfPages = images.count
        
        imagesScrollView.contentSize = CGSize(width: imagesScrollView.frame.size.width * CGFloat(images.count), height: imagesScrollView.frame.size.height)
    }
    
    private func addOrRemoveDefault() {
        if images.count == 0 {
            images.append(UIImage(named: "default")!)
        } else if images[0] == UIImage(named: "default") {
            images.remove(at: 0)
        }
    }
    
    private func setupImages(index: Int) {
        frame.origin.x = imagesScrollView.frame.size.width * CGFloat(index)
        frame.size = imagesScrollView.frame.size
        
        let imageView = UIImageView(frame: frame)
        imageView.image = images[index]
        
        self.imagesScrollView.addSubview(imageView)
    }
    
    
    // MARK:- Actions
    @objc private func closeBtnPressed() {
        presenter.close()
    }
    
    @objc private func saveBtnPressed() {
        presenter.saveChanges()
    }

    @objc private func shareBtnPressed() {
        presenter.share()
    }

    @objc private func bookmarkBtnPressed() {
        presenter.addToFavorites()
    }
    
    @objc private func deleteBtnPressed() {
        let alert = UIAlertController(title: "Delete the Note", message: "Are you sure you want to delete the note?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.presenter.deleteNote()
        })
        alert.addAction(action)
        self.show(alert, sender: nil)
    }
    
    @objc private func editBtnPressed() {
        presenter.editNote()
    }
    
    @objc private func imagePressed() {
        openImagePicker()
    }
    
    private func openImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc private func detailBtnPressed() {
        presenter.showImagesDetail()
    }
}

extension NoteViewController {
    // MARK: Protocol Methods
    func varyContent(isEditing: Bool) {
        // method for changing content depending on mode
        setupViewAppearence()
        autoLayout.activateModeConstraints(mode: self.mode)
    }
    
    private func setupViewAppearence() {
        // hide or unhide subviews depending on mode
        let isEditing = (self.mode == .edit)
        saveBtn.isHidden = !isEditing
        addImageBtn.isHidden = !isEditing
        detailBtn.isHidden = isEditing
        editBtn.isHidden = isEditing
        shareBtn.isHidden = isEditing
        bookmarkBtn.isHidden = isEditing
        deleteBtn.isHidden = isEditing
        noteTextView.isEditable = isEditing
        noteTextView.textColor = isEditing ? .gray : .black
    }
    
    func updateText() {
        // update written text
        self.text = noteTextView.text
    }
    
    func turnOnEditMode() {
        // method for turning on the edit mode
        self.mode = .edit
        self.titleLabel.text = "Editing"
        presenter.configureViewContent()
    }
    
    func showActivityVC(with items: [Any]) {
        // sharing menu
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func showNotifyAlert() {
        let alert = initDefaultAlert(title: "Unable to add the note to the bookmarks", message: "Your note is already in it", actionHandler: nil)
        self.show(alert, sender: nil)
    }
    
    func showSaveNoteAlert() {
        // save alert
        let alert = UIAlertController(title: "Save", message: "Please enter your note's name", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { tf in
            tf.text = self.noteTitle
        })
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: {_ in
            self.saveAlertHandler(alert: alert)
        })
        alert.addAction(action)
        self.show(alert, sender: nil)
    }
    
    private func saveAlertHandler(alert: UIAlertController) {
        // check data
        if alert.textFields![0].text?.trimmingCharacters(in: .whitespaces) == "" {
            self.errorAlert()
        } else {
            self.noteTitle = alert.textFields![0].text!
            self.presenter.titleChoosedSuccessfully()
        }
    }
    
    private func errorAlert() {
        let alert = initDefaultAlert(title: "Incorrect Data", message: "Write your note name again, please", actionHandler: nil)
        self.show(alert, sender: nil)
    }
}

extension NoteViewController: UIScrollViewDelegate {
    // MARK:- UIScrollView
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(round(pageNumber))
    }
}


extension NoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK:- UIImagePickerController
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        images.append(selectedImage)
        self.setupScrollView()
        picker.dismiss(animated: true)
    }
}

extension NoteViewController: UITextViewDelegate {
    // MARK:- UITextView
    // These methods configure textView's behaviour
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Note information here..." {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Note information here..."
            textView.textColor = .gray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}

// global functions to convert images
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
