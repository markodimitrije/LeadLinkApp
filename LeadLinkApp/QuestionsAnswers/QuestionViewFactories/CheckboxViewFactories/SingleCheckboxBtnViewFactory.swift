//
//  SingleCheckboxBtnViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class SingleCheckboxBtnViewFactory: GetViewProtocol {
   
    var myView: UIView!

    private var checkboxBtnOnImg = CheckboxBtnImage().onImage
    private var checkboxBtnOffImg = CheckboxBtnImage().offImage
    
    func getView() -> UIView {
        return myView
    }
    
    init(tag: Int, isOn: Bool, titleText: String) {
        
        let checkboxButton = UIButton()
        let img = isOn ? checkboxBtnOnImg : checkboxBtnOffImg
        checkboxButton.setBackgroundImage(img, for: .normal)
        
        checkboxButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        checkboxButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        //Big Button (View size)
        let button = UIButton()
        
        //Text Label
        button.titleLabel!.numberOfLines = 0
        button.setTitleColor(.black, for: .normal)
        button.setTitle(titleText, for: .normal)
        button.contentHorizontalAlignment = .left
        
        button.heightAnchor.constraint(equalTo: button.titleLabel!.heightAnchor, multiplier: 1.0).isActive = true
        
        //Stack View
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8.0

        stackView.addArrangedSubview(checkboxButton)
        stackView.addArrangedSubview(button)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        
        myView = stackView
        
        _ = [checkboxButton, button, myView].map {
            $0.tag = tag
        }

    }
    
}


