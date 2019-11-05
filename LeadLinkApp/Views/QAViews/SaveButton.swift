//
//  SaveButton.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 24/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

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
    
}

