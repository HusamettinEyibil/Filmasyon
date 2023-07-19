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
        self.indicatorContainer = UIView(frame: self.view.bounds)
        indicator?.frame = self.indicatorContainer!.bounds
        indicatorContainer?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        indicatorContainer?.addSubview(self.indicator!)
        indicator?.startAnimating()
        self.indicatorContainer?.frame = view.bounds
        self.indicator?.frame = self.indicatorContainer!.bounds
        view.addSubview(indicatorContainer!)
    }
    
    func hideLoading() {
        self.indicator?.stopAnimating()
        self.indicator?.removeFromSuperview()
        self.indicatorContainer?.removeFromSuperview()
        self.indicator = nil
        self.indicatorContainer = nil
    }

}
