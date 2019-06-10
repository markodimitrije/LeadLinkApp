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
    
    //    private let privacyPolicyUrl = "https://service.e-materials.com/storage/resources/era_edta/coo/Privacy_Policy.pdf"
    //    private let navusPrivacyPolicyUrl =  "https://www.navus.io/wp-content/uploads/2019/04/Privacy-and-Cookies-Policy-Navus_March_26_2019.pdf"
    //
    //    private let privacyPolicyHyperLinkText = "Privacy Policy"
    //    private let navusPrivacyPolicyHyperLinkText = "Navus Privacy Policy"
    
    @IBOutlet weak var textView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
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
    
    func configureTxtViewWithHyperlinkText(tag: Int) {
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        // hard-coded
        let hyperlink = Constants.PrivacyPolicy.hyperLinkPolicyText
        let url = (tag == 0) ? Constants.PrivacyPolicy.url : Constants.PrivacyPolicy.navusUrl
        let originalText = (tag == 0) ? Constants.TermsNoSwitch.eraText : Constants.TermsNoSwitch.navusText

        textView.hyperLink(originalText: originalText,
                           hyperLinkFirst: hyperlink,
                           urlStringFirst: url)
            //hard-coded
    }
    
//    private func loadDataFrom(disclaimer: Disclaimer) {
//
//        textView.text = disclaimer.text
//    }
    
//    private func getMySize() -> CGSize {
//
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            return getSizeOnIpad()
//        } else if UIDevice.current.userInterfaceIdiom == .phone{
//            return getSizeOnIphone()
//        }
//        return CGSize.zero
//
//    }
//
//    private func getSizeOnIpad() -> CGSize {
//
//        let width = UIScreen.main.bounds.width
//        let height = UIScreen.main.bounds.height
//
//        let side = min(width, height)
//        return CGSize.init(width: 0.75*side, height: 0.75*side)
//
//    }
//
//    private func getSizeOnIphone() -> CGSize {
//
//        let width = UIScreen.main.bounds.width
//        let height = UIScreen.main.bounds.height
//
//        return CGSize.init(width: 0.9*width, height: 0.9*height)
//
//    }
//
//    func getRectForDisclaimerView(center: CGPoint) -> CGRect {
//
//        return CGRect.init(center: center, size: getMySize())
//
//    }
    
}















