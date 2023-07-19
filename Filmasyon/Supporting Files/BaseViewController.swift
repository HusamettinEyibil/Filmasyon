//
//  BaseViewController.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 15.07.2023.
//

import UIKit

class BaseViewController: UIViewController {

    var indicatorContainer: UIView?
    var indicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func showLoading() {
        self.indicator = UIActivityIndicatorView(style: .whiteLarge)
        self.indicatorContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width/3, height: view.bounds.height/5))
        self.indicatorContainer?.center = view.center
        self.indicatorContainer?.corner(10)
        indicator?.frame = self.indicatorContainer!.bounds
        indicatorContainer?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        indicatorContainer?.addSubview(self.indicator!)
        indicator?.startAnimating()
        view.addSubview(indicatorContainer!)
        view.bringSubviewToFront(indicatorContainer!)
    }
    
    func hideLoading() {
        self.indicator?.stopAnimating()
        self.indicator?.removeFromSuperview()
        self.indicatorContainer?.removeFromSuperview()
        self.indicator = nil
        self.indicatorContainer = nil
    }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }

}
