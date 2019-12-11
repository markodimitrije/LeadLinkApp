//
//  UITextView+Extensions.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit


extension UITextView {
    
    func hyperLink(originalText: String, hyperLink: String, urlString: String) {

        let style = NSMutableParagraphStyle()
        style.alignment = .justified

        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        let fullRange = NSMakeRange(0, attributedOriginalText.length)

        attributedOriginalText.addAttribute(.link, value: urlString, range: linkRange)
        attributedOriginalText.addAttribute(.foregroundColor, value: UIColor.black, range: fullRange)
        attributedOriginalText.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: fullRange)

        self.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.blue,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        ]

        self.attributedText = attributedOriginalText
    }
    
    func hyperLink(originalText: String, hyperLinkFirst: String, urlStringFirst: String,
                   hyperLinkSecond: String, urlStringSecond: String) {
        
        let style = NSMutableParagraphStyle()
        style.alignment = .justified
        
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let linkRangeFirst = attributedOriginalText.mutableString.range(of: hyperLinkFirst)
        let linkRangeSecond = attributedOriginalText.mutableString.range(of: hyperLinkSecond)
        let fullRange = NSMakeRange(0, attributedOriginalText.length)
        
        attributedOriginalText.addAttribute(.link, value: urlStringFirst, range: linkRangeFirst)
        attributedOriginalText.addAttribute(.link, value: urlStringSecond, range: linkRangeSecond)
        
//        attributedOriginalText.addAttribute(.paragraphStyle, value: style, range: fullRange)
        attributedOriginalText.addAttribute(.foregroundColor, value: UIColor.black, range: fullRange)
        attributedOriginalText.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: fullRange)
        
        self.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.blue,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        
        self.attributedText = attributedOriginalText
    }
}

extension UITextView {
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}

