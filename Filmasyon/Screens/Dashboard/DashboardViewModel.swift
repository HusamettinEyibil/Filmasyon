//
//  DashboardViewModel.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 14.07.2023.
//

import Foundation

protocol DashboardViewModelDelegate: AnyObject {
    func showDetail(for movie: MovieModel)
}

class DashboardViewModel {
    
    init(manager: NetworkManager) {
        self.manager = manager
    }
    
    private let manager: NetworkProtocol!
    private var models: [MovieModel] = []
    private var searchKey = "star"
    
    weak var delegate: DashboardViewModelDelegate?
    
}

//MARK: View Controller Protocol Methods
extension DashboardViewModel: DashboardViewModelProtocol {
    
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
    
    func didSelectRow(at indexPath: IndexPath) {
        let movie = models[indexPath.row]
        delegate?.showDetail(for: movie)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let movie = models[indexPath.row]
        delegate?.showDetail(for: movie)
    }
    
    func searchMovies(completion: @escaping (Result<([MovieModel], Int?), NetworkError>) -> Void) {
        manager.searchMovies(with: searchKey) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                self.models.append(contentsOf: response.0)
                completion(.success(response))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func setSearchKey(with key: String) {
        self.searchKey = key
    }
}
