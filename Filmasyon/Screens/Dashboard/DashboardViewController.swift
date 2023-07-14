//
//  DashboardViewController.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 14.07.2023.
//

import UIKit

protocol DashboardViewModelProtocol: AnyObject {
    var delegate: DashboardViewModelDelegate? { get set }
}

class DashboardViewController: UIViewController {
        
    var viewModel: DashboardViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

}

//MARK: View Model Delegate Methods
extension DashboardViewController: DashboardViewModelDelegate {
    
}
