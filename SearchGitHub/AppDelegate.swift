//
//  AppDelegate.swift
//  SearchGitHub
//
//  Created by Ana Mamic on 29/11/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let navigationService = NavigationService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationService.pushInitialScreen(window: window)
        return true
    }

}

