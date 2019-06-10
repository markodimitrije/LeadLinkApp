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
    
//    @IBAction func leftBtnTapped(_ sender: UIButton) {
//        delegate?.consent(hasConsent: false)
//    }
//    @IBAction func rightBtnTapped(_ sender: UIButton) {
//        delegate?.consent(hasConsent: true)
//    }
//
//    weak var delegate: ConsentAproving?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    convenience init(frame: CGRect, disclaimer: Disclaimer) {
        self.init(frame: frame)
        //        let frame = getRectForDisclaimerView(center: center)
        loadDataFrom(disclaimer: disclaimer)
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
        
        format()
        
        self.addSubview(view)
        
    }
    
    func configureTxtViewWithHyperlinkText(tag: Int) {
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        // hard-coded
        let hyperlink = (tag == 0) ? Constants.PrivacyPolicy.hyperLinkPolicyText : Constants.PrivacyPolicy.hyperLinkPolicyText
        let url = (tag == 0) ? Constants.PrivacyPolicy.url : Constants.PrivacyPolicy.url


        textView.hyperLink(originalText: Constants.Disclaimer.text,
                           hyperLinkFirst: hyperlink,
                           urlStringFirst: url)
            //hard-coded
    }
    
    private func loadDataFrom(disclaimer: Disclaimer) {
        
        textView.text = disclaimer.text
    }
    
    private func format() {
//        formatView()
//        formatDisagree()
//        formatAgree()
    }
    
//    private func formatView() {
//        holderView.layer.cornerRadius = 10.0
//    }
    
//    private func formatDisagree() {
//        disagreeBtn.layer.cornerRadius = disagreeBtn.bounds.height/2
//        disagreeBtn.layer.borderWidth = 1.0
//        disagreeBtn.layer.borderColor = UIColor.disclaimerBlue.cgColor
//    }
//
//    private func formatAgree() {
//        agreeBtn.layer.cornerRadius = disagreeBtn.bounds.height/2
//    }
    
    private func getMySize() -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return getSizeOnIpad()
        } else if UIDevice.current.userInterfaceIdiom == .phone{
            return getSizeOnIphone()
        }
        return CGSize.zero
        
    }
    
    private func getSizeOnIpad() -> CGSize {
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        let side = min(width, height)
        return CGSize.init(width: 0.75*side, height: 0.75*side)
        
    }
    
    private func getSizeOnIphone() -> CGSize {
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        return CGSize.init(width: 0.9*width, height: 0.9*height)
        
    }
    
    func getRectForDisclaimerView(center: CGPoint) -> CGRect {
        
        return CGRect.init(center: center, size: getMySize())
        
    }
    
}















