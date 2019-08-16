//
//  AppDelegate.swift
//  NewsTest
//
//  Created by Victor on 15/08/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let viewModel = NewsListViewModel()
        let newsListController = NewsListController(viewModel: viewModel)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = newsListController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

