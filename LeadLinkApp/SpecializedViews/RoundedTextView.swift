//
//  File.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 26/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class RoundedTextView: OptionsTextView, ViewRounding {
    
    private var lineWidth: CGFloat = 1.0
    private var color: UIColor = .lightGray
    private var cornerRadius: CGFloat = 5.0
    
    init(frame: CGRect, lineWidth: CGFloat?, color: UIColor?, cornerRadius: CGFloat?) {
        
        if let lineWidth = lineWidth { self.lineWidth = lineWidth }
        if let color = color { self.color = color }
        if let cornerRadius = cornerRadius { self.cornerRadius = cornerRadius }
        super.init(frame: frame, textContainer: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        formatBorder()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        formatBorder()
    }
    
    private func formatBorder() {
        self.drawBorder(withLineWidth: self.lineWidth, andColor: self.color)
        self.roundCorner(withRadius: self.cornerRadius)
    }
    
}
