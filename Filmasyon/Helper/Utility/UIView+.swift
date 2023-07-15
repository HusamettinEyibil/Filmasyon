//
//  UIView+.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 15.07.2023.
//

import UIKit

extension UIView {
    func border(_ color: UIColor,_ width: CGFloat ) {
        self.layer.masksToBounds = true
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func corner(_ radius: CGFloat ) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
}
