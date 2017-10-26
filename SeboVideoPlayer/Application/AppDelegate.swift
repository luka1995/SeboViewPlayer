//
//  AppDelegate.swift
//  SeboVideoPlayer
//
//  Created by Luka Penger on 25/10/2017.
//  Copyright © 2017 Luka Penger. All rights reserved.
//

import UIKit


// MARK: AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Variables
    
    var window: UIWindow?
    
    // MARK: Application
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        
        self.window?.rootViewController = ViewController()
        
        self.window?.makeKeyAndVisible()

        return true
    }

}

