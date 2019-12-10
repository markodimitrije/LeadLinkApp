//
//  CodeHorizontalStacker.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class CodeHorizontalStacker: GetViewProtocol {
    
    var myView: UIView
    
    func getView() -> UIView {
        return myView
    }
    
    init(views: [UIView], distribution: UIStackView.Distribution) {

        //Stack View
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = distribution
        stackView.alignment = .center
        stackView.spacing = 8.0

        //stackView.translatesAutoresizingMaskIntoConstraints = false;
        
        _ = views.map { subview -> () in
            stackView.addArrangedSubview(subview)
        }
        
        myView = stackView

    }
    
}
