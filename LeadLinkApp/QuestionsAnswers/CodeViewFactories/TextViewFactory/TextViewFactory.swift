//
//  TextViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class TextViewFactory: TextViewFactoryProtocol {
    
    private var myView: UIView
    
    weak var delegate: UITextViewDelegate?
    
    func getView() -> UIView {
        return myView
    }
    
    init(inputText: String, placeholderText: String, questionId: Int? = nil, width: CGFloat? = nil) {
        
        func getTextColor(inputText: String, placeholderText: String) -> UIColor {
            if placeholderText == "" { return .black }
            if inputText == "" { return .lightGray }
            return (inputText != placeholderText) ? .black : .lightGray
        }
        
        func getText(inputText: String, placeholderText: String) -> String {
            if inputText == "" || inputText == placeholderText {
                return placeholderText
            }
            return inputText
        }
        
        //textField
        let textView = UITextView()
        textView.backgroundColor = .yellow
        textView.isScrollEnabled = false
        textView.font = UIFont(name: "Helvetica", size: 24.0)
        textView.makeRoundedBorder(color: .darkGray, cornerRadius: 5.0)
        textView.returnKeyType = UIReturnKeyType.done
        
        textView.tag = questionId ?? 0 // hard-coded proveri, mislim da su tagovani na level: LabelWithTextViewFactory
        
        textView.text = getText(inputText: inputText, placeholderText: placeholderText)
        textView.textColor = getTextColor(inputText: inputText, placeholderText: placeholderText)
        
        if let width = width {
            textView.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        //Stack View
//        let stackView = UIStackView()
//        stackView.addArrangedSubview(textView)
//
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        myView = stackView
        
        myView = textView
        
        textView.textContainerInset = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        
    }

}
