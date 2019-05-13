//
//  OptionsTextView.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 13/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class OptionsTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: nil)
        formatLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        formatLayout()
    }
    func formatLayout() {
        self.tintColor = UIColor.clear
        if let oneRowStacker = UIView.closestParentObject(for: self, ofType: OneRowStacker.self) {
            oneRowStacker.resizeHeight(by: 20)
            self.resizeHeight(by: 20)
        }
    }
    
    func formatLayout(accordingToOptions options: [String]) {
        if options.count > 1 {
            self.sizeToFit()
        } else {
            self.frame = CGRect.init(origin: self.frame.origin,
                                     size: CGSize.init(width: self.bounds.width, height: 80))
        }
        formatLayout()
    }
    
    private func setCursor(toPosition position: UITextPosition) {
        self.selectedTextRange = self.textRange(from: position, to: position)
    }
}
