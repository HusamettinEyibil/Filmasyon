//
//  DetailBuilder.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 15.07.2023.
//

import Foundation

class DetailBuilder {
    static func build() -> DetailViewController {
        let viewController = DetailViewController()
        viewController.viewModel = DetailViewModel()
        return viewController
    }
}
