//
//  BarcodeTextViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class BarcodeTextViewFactory: TextInputViewFactoryProtocol {
    
    private var myView: UIView
    
    weak var delegate: UITextViewDelegate?
    
    func getView() -> UIView {
        return myView
    }
    
    init(inputText: String, width: CGFloat? = nil) {
        
        //textField
        let textView = UITextView()
        textView.backgroundColor = .lightGray
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.font = UIFont(name: "Helvetica", size: 24.0)
        textView.makeRoundedBorder(color: .darkGray, cornerRadius: 5.0)
        
        textView.text = inputText
        textView.textColor = .black
        
        if let width = width {
            textView.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        myView = textView
        
        textView.textContainerInset = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        
    }
}
