//
//  NetworkManager.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 15.07.2023.
//

import Foundation

protocol NetworkProtocol: AnyObject {
    func searchMovies(with searchKey: String, completion: @escaping (Result<([MovieModel], Int?), NetworkError>) -> Void)
    func downloadImage(with urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

class NetworkManager: NetworkProtocol {
    
    let session = URLSession.shared
    
    var pageToFetch = 1
    
    func searchMovies(with searchKey: String, completion: @escaping (Result<([MovieModel], Int?), NetworkError>) -> Void) {
        guard let url = UrlManager().getSearchUrl(for: searchKey, page: pageToFetch) else {
            completion(.failure(.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        session.dataTask(with: request) { [weak self] data, response, error in
            if error != nil {
                completion(.failure(.failedToGetMovies))
            } else if let data {
                do {
                    self?.pageToFetch += 1
                    let responseModel = try JSONDecoder().decode(MovieResponseModel.self, from: data)
                    completion(.success((responseModel.searchResults, Int(responseModel.totalResults))))
                } catch {
                    completion(.failure(.failedToDecodeData))
                }
            }
        }.resume()
    }
    
    func downloadImage(with urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.failedToDownloadImage))
            } else if let data {
                completion(.success(data))
            }
        }.resume()
    }
}
