//
//  CodeVerticalStacker.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class CodeVerticalStacker: GetViewProtocol {
    
    var myView: UIView
    
    func getView() -> UIView {
        return myView
    }
    
    init(views: [UIView]) {

        //Stack View
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.distribution  = .fill
        stackView.alignment = .leading
        stackView.spacing = 16.0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false;

        myView = stackView
        //myView = LabelAndTextField(frame: stackView.bounds) // pukne layout, i nema nicega...
    }
}
