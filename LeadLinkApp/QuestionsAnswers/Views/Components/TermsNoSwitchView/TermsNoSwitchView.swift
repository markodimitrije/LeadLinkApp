//
//  TermsNoSwitchView.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import AVFoundation

class TermsNoSwitchView: UIView {
    
    @IBOutlet weak var textView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    override func didMoveToSuperview() {
        formatFontSize()
    }
    
    override func layoutSubviews() {
        formatFontSize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TermsNoSwitchView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
    }
    
    private func formatFontSize() {
        self.textView.font = .systemFont(ofSize: 18)
    }
    
    func configureTxtViewWithHyperlinkText(tag: Int, optIn: OptIn?) {
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        
        let hyperlink = optIn?.privacyPolicy ?? Constants.PrivacyPolicy.hyperLinkPolicyText
        let url = optIn?.url ?? Constants.PrivacyPolicy.navusUrl
        
        var text = ""
        
        if let textBase = optIn?.text {
            text = textBase + " " + hyperlink
        } else {
            text = Constants.TermsNoSwitch.navusText
        }
        
        textView.hyperLink(originalText: text,
                           hyperLinkFirst: hyperlink,
                           urlStringFirst: url)
    }
    
}
