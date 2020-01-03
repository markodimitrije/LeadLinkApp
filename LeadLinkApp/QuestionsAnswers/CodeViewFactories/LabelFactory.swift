//
//  LabelFactory.swift
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
//        let textLabel = PaddingLabel()
        //textLabel.backgroundColor = .cyan
        textLabel.numberOfLines = 0
        textLabel.text = text
        textLabel.textAlignment = .left
        textLabel.font = UIFont(name: "Helvetica", size: 20.0)
        
        if text != "" {
            textLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 44.0).isActive = true
        }
        
        if let width = width {
            textLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        myView = textLabel
        //myView = LabelAndTextField(frame: stackView.bounds) // pukne layout, i nema nicega...
    }
    
}

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 8.0
    @IBInspectable var bottomInset: CGFloat = 8.0
    @IBInspectable var leftInset: CGFloat = 8.0
    @IBInspectable var rightInset: CGFloat = 8.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
