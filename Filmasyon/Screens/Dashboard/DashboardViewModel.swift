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
        manager.searchMovies(with: searchKey) { [weak self] result in
            guard let self else { return }
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
    
    func downloadImage(with urlString: String, imdbId: String, completion: ((Data?, Error?) -> Void)?) {
        if let data = appContainer.sessionManager.cachedImages[imdbId] {
            completion?(data, nil)
        } else {
            manager.downloadImage(with: urlString) { result in
                switch result {
                case let .success(data):
                    appContainer.sessionManager.cachedImages[imdbId] = data
                    completion?(data, nil)
                case let .failure(error):
                    completion?(nil, error)
                }
            }
        }
    }
}
