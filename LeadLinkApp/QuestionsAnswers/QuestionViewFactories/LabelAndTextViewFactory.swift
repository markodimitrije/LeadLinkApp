//
//  LabelAndTextViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class LabelAndTextViewFactory:  GetViewProtocol {
    
    private let labelFactory: LabelFactory
    private let textViewFactory: TextViewFactoryProtocol
    private var myView: UIView!
    
    weak var delegate: UITextViewDelegate?
    
    func getView() -> UIView {
        return myView
    }
    
    init(labelFactory: LabelFactory, textViewFactory: TextViewFactoryProtocol) {
        self.labelFactory = labelFactory
        self.textViewFactory = textViewFactory
        loadView()
    }
    
    private func loadView() {
        
        //Text Label
        let textLabel = labelFactory.getView()
        
        //textField
        let textView = textViewFactory.getView()
        
        //Stack View
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 8.0

        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(textView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false

        myView = stackView
    }
}


