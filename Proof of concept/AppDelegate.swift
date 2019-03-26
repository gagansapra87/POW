//
//  AppDelegate.swift
//  Proof of concept
//
//  Created by MAC on 17/03/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       
        self.setRootViewController()
        
            return true
    }

    //MARK: SetRootViewContoller
    
    func setRootViewController() {
        
        /*
         intialise viewcontroller
         */
     
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = ViewController() as UIViewController
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.isTranslucent = false
        self.window?.rootViewController = nc
        self.window?.makeKeyAndVisible()
    }
}

