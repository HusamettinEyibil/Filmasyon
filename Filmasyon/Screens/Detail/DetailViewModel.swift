//
//  DetailViewModel.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 15.07.2023.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func configure(with movie: MovieModel)
}

class DetailViewModel {
    
    init(movie: MovieModel) {
        self.movie = movie
    }
    
    weak var delegate: DetailViewModelDelegate?
    
    private let movie: MovieModel


    
}

//MARK: View Controller Protocol Methods
extension DetailViewModel: DetailViewModelProtocol {
    func viewDidLoad() {
        delegate?.configure(with: movie)
    }
    
    func getCachedImage(imdbId: String, completion: ((Data?, Error?) -> Void)?) {
        if let data = appContainer.sessionManager.cachedImages[imdbId] {
            completion?(data, nil)
        } else {
            completion?(nil, SessionError.failedToGetCachedImage)
        }
    }
}
