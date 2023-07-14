//
//  DashboardViewModel.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 14.07.2023.
//

import Foundation

protocol DashboardViewModelDelegate: AnyObject {
    
}

class DashboardViewModel {
    
    weak var delegate: DashboardViewModelDelegate?
    
}

//MARK: View Controller Protocol Methods
extension DashboardViewModel: DashboardViewModelProtocol {
    
}
