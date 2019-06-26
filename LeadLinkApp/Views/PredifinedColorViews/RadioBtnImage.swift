//
//  RadioBtnImage.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 26/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class RadioBtnImage {
    
    var onImage: UIImage!
    var offImage: UIImage!
    
    private var outerView: UIView!
    private var innerOnView: UIView!
    private var innerOffView: UIView!
    
    private let outerCircleWidth = CGFloat(50)
    private let innerCircleWidth = CGFloat(30)
    
    init() {
        loadImageView()
    }
    
    private func loadImageView() {
        makeOuterCircle()
        makeInnerViewOn()
        makeInnerViewOff()
        composeImageViewFromOuterAndInnerCircle()
    }
    
    private func makeOuterCircle() {
        let outerRect = CGRect.init(origin: .zero, size: CGSize.init(width: outerCircleWidth, height: outerCircleWidth))
        self.outerView = UIView.init(frame: outerRect)
        formatOuterCircle()
    }
    
    private func formatOuterCircle() {
        outerView.layer.borderWidth = 1.0
        outerView.layer.cornerRadius = self.outerView.bounds.width/2
        outerView.layer.borderColor = UIColor.leadLinkColor.cgColor
    }
    
    private func makeInnerViewOn() {
        let innerRect = CGRect.init(origin: .zero, size: CGSize.init(width: innerCircleWidth, height: innerCircleWidth))
        self.innerOnView = UIView.init(frame: innerRect)
        innerOnView.layer.cornerRadius = 0.5
        innerOnView.layer.cornerRadius = self.innerOnView.bounds.width/2
        innerOnView.layer.backgroundColor = UIColor.leadLinkColor.cgColor
    }
    
    private func makeInnerViewOff() {
        let innerRect = CGRect.init(origin: .zero, size: CGSize.init(width: innerCircleWidth, height: innerCircleWidth))
        self.innerOffView = UIView.init(frame: innerRect)
        innerOffView.layer.cornerRadius = 0.5
        innerOffView.layer.cornerRadius = self.innerOnView.bounds.width/2
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
