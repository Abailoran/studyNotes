//
//  PhotoAutoLayout.swift
//  StudyNotes
//
//  Created by Abailoran on 4/19/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import UIKit

class PhotoAutoLayout {
    // MARK:- Properties
    weak var closeBtn: UIButton!
    weak var pageLabel: UILabel!
    weak var scrollView: UIScrollView!
    weak var pageControl: UIPageControl!
    weak var view: UIView!
    var innerViews = [UIView]()
    
    
    // MARK:- Initialization
    required init(closeBtn: UIButton, pageLabel: UILabel, scrollView: UIScrollView, pageControl: UIPageControl, view: UIView) {
        self.closeBtn = closeBtn
        self.pageLabel = pageLabel
        self.scrollView = scrollView
        self.pageControl = pageControl
        self.view = view
        
        addViewsToInnerViewsArray()
        addInnerViewsToTheViewAndAutoresizingFalse()
        activateConstraints()
    }
    
    // MARK:- Layout
    private func addViewsToInnerViewsArray() {
        innerViews.append(closeBtn)
        innerViews.append(pageLabel)
        innerViews.append(scrollView)
        innerViews.append(pageControl)
    }
    
    private func addInnerViewsToTheViewAndAutoresizingFalse() {
        for innerView in innerViews {
            view.addSubview(innerView)
            innerView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    
    // MARK:- Constraints
    func activateConstraints() {
        let btnSide = view.frame.width * 0.15
        NSLayoutConstraint.activate([
            pageLabel.leadingAnchor.constraint(equalTo: closeBtn.trailingAnchor, constant: 8),
            pageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(btnSide + 12)),
            pageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            closeBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            closeBtn.centerYAnchor.constraint(equalTo: pageLabel.centerYAnchor),
            closeBtn.widthAnchor.constraint(equalToConstant: btnSide),
            closeBtn.heightAnchor.constraint(equalToConstant: btnSide),
            
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(btnSide + 24)),
            scrollView.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 24),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            pageControl.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16)
        ])
    }
}
