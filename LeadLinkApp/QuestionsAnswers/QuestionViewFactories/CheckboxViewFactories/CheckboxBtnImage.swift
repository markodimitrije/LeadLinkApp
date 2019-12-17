//
//  CheckboxBtnImage.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 26/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class CheckboxBtnImage {
    
    var onImage: UIImage!
    var offImage: UIImage!
    
    private var outerView: UIView!
    private var innerOnView: UIView!
    private var innerOffView: UIView!
    
    private let outerBorderWidth = CGFloat(50)
    private let innerBorderWidth = CGFloat(49)
    private let checkmarkImage = UIImage.init(named: "checkmark_clear")
    
    init() {
        loadImageView()
    }
    
    private func loadImageView() {
        makeOuterBorder()
        makeInnerViewOn()
        makeInnerViewOff()
        composeImageViewFromOuterAndInnerCircle()
    }
    
    private func makeOuterBorder() {
        let outerRect = CGRect.init(origin: .zero, size: CGSize.init(width: outerBorderWidth,
                                                                     height: outerBorderWidth))
        self.outerView = UIView.init(frame: outerRect)
        formatOuterBorder()
    }
    
    private func formatOuterBorder() {
        outerView.layer.borderWidth = 1.0
        outerView.layer.borderColor = UIColor.leadLinkColor.cgColor
    }
    
    private func makeInnerViewOn() {
        
        let innerRect = CGRect.init(origin: .zero, size: CGSize.init(width: innerBorderWidth,
                                                                     height: innerBorderWidth))
        self.innerOnView = UIView.init(frame: innerRect)
        innerOnView.layer.backgroundColor = UIColor.leadLinkColor.cgColor
        
        addCheckmarkToOnView()
    }
    
    private func addCheckmarkToOnView() {
        let checkmarkImgView = UIImageView.init(image: checkmarkImage)
        checkmarkImgView.frame = innerOnView.bounds
        innerOnView.addSubview(checkmarkImgView)
    }
    
    private func makeInnerViewOff() {
        let innerRect = CGRect.init(origin: .zero, size: CGSize.init(width: innerBorderWidth,
                                                                     height: innerBorderWidth))
        self.innerOffView = UIView.init(frame: innerRect)
        innerOffView.layer.backgroundColor = UIColor.white.cgColor
    }
    
    private func composeImageViewFromOuterAndInnerCircle() {
        
        innerOnView.center = outerView.center
        innerOffView.center = outerView.center
        guard let finalView = outerView else {fatalError()}
        
        finalView.addSubview(innerOnView)
        self.onImage = UIImage(view: finalView)
        
        finalView.removeAllSubviews()
        finalView.addSubview(innerOffView)
        self.offImage = UIImage(view: finalView)
        
    }
    
}
