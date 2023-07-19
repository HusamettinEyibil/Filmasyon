//
//  UISearchBar+.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 19.07.2023.
//

import UIKit

extension UISearchBar {
    func addDoneButtonToKeyboard(target: Any, selector: Selector, tag: Int? = 1) {
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: target, action: selector)
        doneButton.tag = tag ?? 1
        doneButton.tintColor = UIColor.darkGray
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton]
        toolbar.barTintColor = UIColor.white
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
}
