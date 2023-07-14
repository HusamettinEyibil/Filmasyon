//
//  DashboardBuilder.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 14.07.2023.
//

import UIKit

class DashboardBuilder {
    static func build() -> DashboardViewController {
        let viewController = DashboardViewController()
        viewController.viewModel = DashboardViewModel()
        return viewController
    }
}
