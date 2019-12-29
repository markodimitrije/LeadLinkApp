//
//  SaveButtonFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class SaveButtonFactory {
    
    private var myView: UIView
    
    func getView() -> UIView {
        return myView
    }
    
    init(title: String, width: CGFloat, color: UIColor? = UIColor.leadLinkColor) {
        
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: width*0.8).isActive = true
//        button.widthAnchor.constraint(greaterThanOrEqualToConstant: width*0.5).isActive = true
        
        button.backgroundColor = color
        button.setTitle(title, for: .normal)
        button.isUserInteractionEnabled = true
        button.makeRoundedBorder(color: color!, cornerRadius: 5.0)
        
        //Stack View
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 8.0

        stackView.addArrangedSubview(button)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false

        //textView.delegate = delegate
        myView = stackView
    }
    
}


