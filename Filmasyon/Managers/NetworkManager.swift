//
//  NetworkManager.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 15.07.2023.
//

import Foundation

protocol NetworkProtocol: AnyObject {
    func searchMovies(with searchKey: String, completion: @escaping (Result<[MovieModel], NetworkError>) -> Void)
}

class NetworkManager: NetworkProtocol {
    
    let session = URLSession.shared
    
    func searchMovies(with searchKey: String, completion: @escaping (Result<[MovieModel], NetworkError>) -> Void) {
        guard let url = UrlManager().getSearchUrl(for: searchKey) else {
            completion(.failure(.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.failedToGetMovies))
            } else if let data {
                do {
//                    let json = try JSONSerialization.jsonObject(with: data)
                    let responseModel = try JSONDecoder().decode(MovieResponseModel.self, from: data)
                    completion(.success(responseModel.searchResults))
                } catch {
                    completion(.failure(.failedToDecodeData))
                }
            }
        }.resume()
        
    }
}
