//
//  PaddingLabel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 23/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class UIHorizontalMarginLabel: UILabel {
    
    var topInset:       CGFloat = 0
    var rightInset:     CGFloat = 0
    var bottomInset:    CGFloat = 0
    var leftInset:      CGFloat = 0
    
    override func drawText(in rect: CGRect) {
        self.setNeedsLayout()
        let insetsRect = rect.insetBy(dx: 8.0, dy: 0.0)
        return super.drawText(in: insetsRect)
    }
}
