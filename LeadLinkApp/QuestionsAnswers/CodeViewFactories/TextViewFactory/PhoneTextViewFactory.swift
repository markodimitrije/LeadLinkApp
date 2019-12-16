//
//  PhoneTextViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import PhoneNumberKit

class PhoneTextFieldFactory: TextInputViewFactoryProtocol {
    
    private var myView: UIView
    
    weak var delegate: UITextViewDelegate?
    
    func getView() -> UIView {
        return myView
    }
    
    init(inputText: String, placeholderText: String, width: CGFloat? = nil) {
        
        func getTextColor(inputText: String, placeholderText: String) -> UIColor {
            if inputText == "" { return .lightGray }
            return (inputText != placeholderText) ? .black : .lightGray
        }
        
        func getText(inputText: String, placeholderText: String) -> String {
            if inputText == "" || inputText == placeholderText {
                return placeholderText
            }
            return inputText
        }
        
        let textField = PhoneNumberTextField()
        textField.backgroundColor = .yellow
        textField.keyboardType = .phonePad
        textField.font = UIFont(name: "Helvetica", size: 24.0)
        textField.makeRoundedBorder(color: .darkGray, cornerRadius: 5.0)
        
        textField.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        textField.text = getText(inputText: inputText, placeholderText: placeholderText)
        textField.textColor = getTextColor(inputText: inputText, placeholderText: placeholderText)
        
        if let width = width {
            textField.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        self.myView = textField
    }
}
