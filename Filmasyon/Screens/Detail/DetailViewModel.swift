//
//  DetailViewModel.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 15.07.2023.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    
}

class DetailViewModel {
    
    weak var delegate: DetailViewModelDelegate?
    
}

//MARK: View Controller Protocol Methods
extension DetailViewModel: DetailViewModelProtocol {
    func viewDidLoad() {
        
    }
}
