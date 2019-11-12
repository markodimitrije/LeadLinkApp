//
//  SaveButton.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 24/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

protocol ButtonWithSpinnerProtocol {
    func startSpinner()
    func stopSpinner()
}

class SaveButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        formatButton()
    }
    
    convenience init() {
        self.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 250, height: 50)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        formatButton()
    }
    
    private func formatButton() {
        setColorAndText()
        roundBtn()
    }
    
    private func setColorAndText() {
        self.backgroundColor = UIColor.leadLinkColor
        let saveText = NSLocalizedString("Strings.Answers.Save", comment: "")
        self.setTitle(saveText, for: .normal)
    }
    
    private func roundBtn() {
        self.layer.cornerRadius = 10.0
    }
    
    deinit {
        self.stopSpinner()
    }
}

extension SaveButton: ButtonWithSpinnerProtocol {
    
    func startSpinner() {
        let frame = CGRect.init(center: CGPoint.init(x: self.bounds.midX, y: self.bounds.midY),
                                size: CGSize.init(width: 0.9*self.bounds.width, height: 0.9*self.bounds.height))
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.backgroundColor = self.backgroundColor
        activityIndicatorView.frame = frame
        activityIndicatorView.startAnimating()
        self.addSubview(activityIndicatorView)
    }
    
    func stopSpinner() {
        self.subviews.first(where: {$0 is UIActivityIndicatorView})?.removeFromSuperview()
    }
}
