//
//  AppDelegate.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 14.07.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = appContainer.router.start()
        
        return true
    }
}

