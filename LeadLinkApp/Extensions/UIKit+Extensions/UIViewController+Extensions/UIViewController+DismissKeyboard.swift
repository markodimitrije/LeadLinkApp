//
//  UIViewController+Extensions.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false // VRH !!
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
