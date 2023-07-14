//
//  AppRouter.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 14.07.2023.
//

import Foundation

import Foundation
import UIKit

class AppRouter {
    func start() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: DashboardBuilder.build())
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        return window
    }
}
