//
//  AppDelegate.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let tbBarControllerConfig = TabBarControllerConfig()
        let tab =  tbBarControllerConfig.tabBarController
        
        window?.rootViewController = JNSplashViewController()
        window?.makeKeyAndVisible()
        
        
        return true
    }

    

}

