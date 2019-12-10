//
//  LabelFactoryProtocol.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

protocol LabelFactoryProtocol: GetViewProtocol {}

class LabelFactory: LabelFactoryProtocol {
    
    private var myView: UIView
    
    func getView() -> UIView {
        return myView
    }
    
    init(text: String, width: CGFloat? = nil) {
        
        //Text Label
        let textLabel = UILabel()
        textLabel.backgroundColor = .blue
        textLabel.numberOfLines = 0
        textLabel.text = text
        textLabel.textAlignment = .left
        
        if let width = width {
            textLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        //Stack View
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 8.0

        stackView.addArrangedSubview(textLabel)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        myView = stackView
        
        //myView = LabelAndTextField(frame: stackView.bounds) // pukne layout, i nema nicega...
    }
    
}


