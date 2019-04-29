//
//  PhotoViewController.swift
//  StudyNotes
//
//  Created by Abailoran on 4/19/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import UIKit

protocol PhotoViewProtocol: class {
    var images: [UIImage] { get set }
}


class PhotoViewController: UIViewController, PhotoViewProtocol {
    // MARK:- Properties
    var presenter: PhotoPresenterProtocol!
    var autoLayout: PhotoAutoLayout!
    var images = [UIImage]()
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            setupLabelText()
        }
    }
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
        return btn
    }()
    private lazy var pageLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont(name: "Helvetica", size: 46)
        lbl.textAlignment = .center
        return lbl
    }()
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        sv.isPagingEnabled = true
        return sv
    }()
    private var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    private var pageControl = UIPageControl(frame: CGRect(x: 50, y: 300, width: 200, height: 20))
    private var configurator: PhotoConfiguratorProtocol = PhotoConfigurator()
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        configureLayout()
        setupPageControl()
        setBackgroundColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupScrollView()
        setupLabelText()
    }
    
    
    // MARK:- Layout
    private func configureLayout() {
        autoLayout = PhotoAutoLayout(closeBtn: closeBtn, pageLabel: pageLabel, scrollView: scrollView, pageControl: pageControl, view: view)
    }
    
    private func setupPageControl() {
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = .white
    }
    
    
    // MARK:- Scroll View
    private func setupScrollView() {
        pageControl.numberOfPages = images.count
        
        for index in 0..<images.count {
            setupFrameAndImageView(index: index)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(images.count), height: scrollView.frame.size.height)
    }
    
    private func setupFrameAndImageView(index: Int) {
        // setting up images in scroll view
        frame.origin.x = scrollView.frame.size.width * CGFloat(index)
        frame.size = scrollView.frame.size
        
        let imageView = UIImageView(frame: frame)
        imageView.image = images[index]
        imageView.contentMode = .scaleAspectFit
        
        self.scrollView.addSubview(imageView)
    }
    
    private func setupLabelText() {
        pageLabel.text = "\(currentPage + 1) / \(images.count)"
    }
    
    
    // MARK:- Actions
    @objc func closeBtnPressed() {
        presenter.closeView()
    }
}

extension PhotoViewController: UIScrollViewDelegate {
    // MARK:- UIScrollView
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        currentPage = Int(round(pageNumber))
    }
}
