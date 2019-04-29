//
//  LoadingView.swift
//  StudyNotes
//
//  Created by Abailoran on 4/15/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import UIKit

// This is a global function for initializating default alert
func initDefaultAlert(title: String, message: String, actionHandler: ()?) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: ({ _ in
        actionHandler
    }))
    
    alert.addAction(action)
    return alert
}

struct LoadingView {
    // Structure which shows and hide loading alert with animated indicator view
    private static var alert: UIAlertController!
    private static var loadingIndicator: UIActivityIndicatorView!
    
    static func loadingAlert(view: UIViewController) {
        LoadingView.alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        LoadingView.loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        view.present(alert, animated: true, completion: nil)
    }
    
    static func dismissAlert(completion: @escaping () -> Void){
        LoadingView.loadingIndicator.stopAnimating()
        LoadingView.alert.dismiss(animated: true, completion: completion)
    }
}
