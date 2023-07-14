//
//  DashboardViewModel.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 14.07.2023.
//

import Foundation

protocol DashboardViewModelDelegate: AnyObject {
    func didFetchMovies(_ output: [MovieModel])
}

class DashboardViewModel {
    
    init(manager: NetworkManager) {
        self.manager = manager
    }
    
    private let manager: NetworkProtocol!
    
    weak var delegate: DashboardViewModelDelegate?

    func searchMovies(with searchKey: String) {
        manager.searchMovies(with: searchKey) { result in
            switch result {
            case let .success(models):
                self.delegate?.didFetchMovies(models)
            case let .failure(error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}

//MARK: View Controller Protocol Methods
extension DashboardViewModel: DashboardViewModelProtocol {
    func viewDidLoad() {
        searchMovies(with: "star")
    }
}
