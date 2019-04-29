//
//  NoteAutoLayout.swift
//  StudyNotes
//
//  Created by Abailoran on 3/30/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import UIKit

class NoteAutoLayout {
    // MARK:- Properties
    weak var view: UIView!
    weak var titleLabel: UILabel!
    weak var backgroundImage: UIImageView!
    weak var noteTextView: UITextView!
    weak var scrollView: UIScrollView!
    weak var closeBtn: UIButton!
    weak var shareBtn: UIButton!
    weak var bookmarkBtn: UIButton!
    weak var deleteBtn: UIButton!
    weak var editBtn: UIButton!
    weak var saveBtn: UIButton!
    weak var addImage: UIButton!
    weak var pageControl: UIPageControl!
    weak var detailBtn: UIButton!
    var innerViews = [UIView]()
    var constraints = [NSLayoutConstraint]()
    var btnSide: CGFloat = 0.0
    
    
    // MARK:- Initialization
    required init(view: UIView, titleLabel: UILabel, backgroundImage: UIImageView, noteTextView: UITextView, scrollView: UIScrollView, closeBtn: UIButton, shareBtn: UIButton, bookmarkBtn: UIButton, deleteBtn: UIButton, editBtn: UIButton, saveBtn: UIButton, addImage: UIButton, pageControl: UIPageControl, detailBtn: UIButton) {
        self.view = view
        self.titleLabel = titleLabel
        self.backgroundImage = backgroundImage
        self.noteTextView = noteTextView
        self.scrollView = scrollView
        self.closeBtn = closeBtn
        self.shareBtn = shareBtn
        self.bookmarkBtn = bookmarkBtn
        self.deleteBtn = deleteBtn
        self.editBtn = editBtn
        self.saveBtn = saveBtn
        self.addImage = addImage
        self.pageControl = pageControl
        self.detailBtn = detailBtn
        
        addViewsToInnerViewsArray()
        addInnerViewsToTheViewAndAutoresizingFalse()
        activateMainConstraints()
        pageControlLayout()
    }
        
    private func addViewsToInnerViewsArray() {
        innerViews.append(titleLabel)
        innerViews.append(backgroundImage)
        innerViews.append(noteTextView)
        innerViews.append(scrollView)
        innerViews.append(closeBtn)
        innerViews.append(shareBtn)
        innerViews.append(bookmarkBtn)
        innerViews.append(deleteBtn)
        innerViews.append(editBtn)
        innerViews.append(saveBtn)
        innerViews.append(addImage)
        innerViews.append(pageControl)
        innerViews.append(detailBtn)
    }
        
    private func addInnerViewsToTheViewAndAutoresizingFalse() {
        for innerView in innerViews {
            view.addSubview(innerView)
            innerView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // MARK:- Constraints
    private func activateMainConstraints() {
        let scrollViewHeight = view.frame.width * 0.6
        btnSide = view.frame.width * 0.15
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: btnSide),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -btnSide),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
            
            closeBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            closeBtn.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeBtn.widthAnchor.constraint(equalToConstant: btnSide),
            closeBtn.heightAnchor.constraint(equalToConstant: btnSide),

            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            scrollView.heightAnchor.constraint(equalToConstant: scrollViewHeight),
            
            noteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noteTextView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 32),
            noteTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(btnSide + 12)),
            
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }
    
    func pageControlLayout() {
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16)
        ])
        view.bringSubviewToFront(pageControl)
    }
    
    func activateModeConstraints(mode: NoteMode) {
        // Because some of the buttons are hidden in different modes, we are initializating different constraints depending on mode
        NSLayoutConstraint.deactivate(constraints)
        if mode == .detail {
            initDetailModeConstraints()
        } else {
            initAddAndEditModeConstraints()
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    private func initDetailModeConstraints() {
        constraints = [
            editBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            editBtn.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            editBtn.widthAnchor.constraint(equalToConstant: btnSide),
            editBtn.heightAnchor.constraint(equalToConstant: btnSide),
            
            shareBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            shareBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shareBtn.widthAnchor.constraint(equalToConstant: btnSide),
            shareBtn.heightAnchor.constraint(equalToConstant: btnSide),
            
            bookmarkBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            bookmarkBtn.trailingAnchor.constraint(equalTo: shareBtn.leadingAnchor, constant: -16),
            bookmarkBtn.widthAnchor.constraint(equalToConstant: btnSide),
            bookmarkBtn.heightAnchor.constraint(equalToConstant: btnSide),
            
            deleteBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            deleteBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            deleteBtn.widthAnchor.constraint(equalToConstant: btnSide),
            deleteBtn.heightAnchor.constraint(equalToConstant: btnSide),
            
            detailBtn.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12),
            detailBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            detailBtn.widthAnchor.constraint(equalToConstant: btnSide),
            detailBtn.heightAnchor.constraint(equalToConstant: btnSide)
        ]
    }
    
    func initAddAndEditModeConstraints() {
        constraints = [
            saveBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            saveBtn.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            saveBtn.widthAnchor.constraint(equalToConstant: btnSide),
            saveBtn.heightAnchor.constraint(equalToConstant: btnSide),
            
            addImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12),
            addImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            addImage.widthAnchor.constraint(equalToConstant: btnSide),
            addImage.heightAnchor.constraint(equalToConstant: btnSide)
        ]
    }
}
