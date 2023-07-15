//
//  DetailViewController.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 15.07.2023.
//

import UIKit

protocol DetailViewModelProtocol: AnyObject {
    var delegate: DetailViewModelDelegate? { get set }
    func viewDidLoad()
}

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

//MARK: View Model Delegate Methods
extension DetailViewController: DetailViewModelDelegate {
    
}
