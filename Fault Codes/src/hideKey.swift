//
//  hideKey.swift
//  serverRead
//
//  Created by Andrei Costin on 6/19/19.
//  Copyright © 2019 Andrei Costin. All rights reserved.
//

import UIKit
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
}


