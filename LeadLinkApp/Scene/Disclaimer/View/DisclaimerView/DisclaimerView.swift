//
//  Disclaimer.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 08/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import AVFoundation

class DisclaimerView: UIView {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var disagreeBtn: UIButton!
    @IBOutlet weak var agreeBtn: UIButton!
    
    @IBAction func leftBtnTapped(_ sender: UIButton) {
        delegate?.consent(hasConsent: false)
    }
    @IBAction func rightBtnTapped(_ sender: UIButton) {
        delegate?.consent(hasConsent: true)
    }
    
    weak var delegate: ConsentAproving?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    convenience init(frame: CGRect, disclaimer: DisclaimerInfo) {
        self.init(frame: frame)
//        let frame = getRectForDisclaimerView(center: center)
        loadDataFrom(disclaimer: disclaimer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DisclaimerView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        format()
        
        self.addSubview(view)
        
    }
    
    func configureTxtView(withText text: String, url: String) {
        textView.isUserInteractionEnabled = true
        textView.isEditable = false

        textView.hyperLink(originalText: text,
                           hyperLink: Constants.PrivacyPolicy.hyperLinkPolicyText,
                           urlString: url)
    }
    
    private func loadDataFrom(disclaimer: DisclaimerInfo) {
        titleLbl.text = disclaimer.title
        textView.text = disclaimer.text
        disagreeBtn.setTitle(disclaimer.disagreeTitle, for: .normal)
        agreeBtn.setTitle(disclaimer.agreeTitle, for: .normal)
    }
    
    private func format() {
        formatView()
        formatDisagree()
        formatAgree()
    }
    
    private func formatView() {
        holderView.layer.cornerRadius = 10.0
    }
    
    private func formatDisagree() {
        disagreeBtn.layer.cornerRadius = disagreeBtn.bounds.height/2
        disagreeBtn.layer.borderWidth = 1.0
        disagreeBtn.layer.borderColor = UIColor.disclaimerBlue.cgColor
    }
    
    private func formatAgree() {
        agreeBtn.layer.cornerRadius = disagreeBtn.bounds.height/2
    }
    
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
    
//    func getRectForDisclaimerView(center: CGPoint) -> CGRect {
//
//        return CGRect.init(center: center, size: getMySize())
//
//    }
    
}

