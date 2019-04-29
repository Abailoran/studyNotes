//
//  AppDelegate.swift
//  StudyNotes
//
//  Created by Abailoran on 2/27/19.
//  Copyright © 2019 Abailoran. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var rootVC: UIViewController!
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        selectRootController()
        setupWindow()
        window?.makeKeyAndVisible()
        return true
    }
    
    func selectRootController() {
        if UserDefaults.standard.object(forKey: "isTheFirstTime") == nil {
            rootVC = WelcomeViewController()
        } else {
            rootVC = ContainerViewController()
        }
    }
    
    func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootVC
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataService.saveContext()
    }
}

