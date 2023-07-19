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
    private var tableModels: [MovieModel] = []
    private var collectionModels: [MovieModel] = []
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
        let movie = tableModels[indexPath.row]
        delegate?.showDetail(for: movie)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let movie = collectionModels[indexPath.row]
        delegate?.showDetail(for: movie)
    }
    
    func searchMovies(type: SearchType, isNewSearch: Bool, completion: @escaping (Result<([MovieModel], Int?), NetworkError>) -> Void) {
        manager.searchMovies(with: searchKey) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                self.handleResponse(movies: response.0, type: type, isNewSearch: isNewSearch)
                completion(.success(response))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func handleResponse(movies: [MovieModel], type: SearchType, isNewSearch: Bool) {
        switch type {
        case .TableView:
            if isNewSearch {
                tableModels = movies
            } else {
                tableModels.append(contentsOf: movies)
            }
        case .CollectionView:
            if isNewSearch {
                collectionModels = movies
            } else {
                collectionModels.append(contentsOf: movies)
            }
        }
    }
    
    func setSearchKey(with key: String) {
        self.searchKey = key
    }
}
