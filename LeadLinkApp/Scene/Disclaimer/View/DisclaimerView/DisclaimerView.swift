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
    
    convenience init(frame: CGRect, disclaimerInfo: DisclaimerViewInfo) {
        self.init(frame: frame)
        loadMyOutlets(from: disclaimerInfo)
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
    
    private func loadMyOutlets(from disclaimerViewInfo: DisclaimerViewInfo) {
        titleLbl.text = disclaimerViewInfo.title
        
        let disclaimer = disclaimerViewInfo.disclaimer
        textView.hyperLink(originalText: disclaimer.text + " " + disclaimer.privacyPolicy,
                           hyperLink: disclaimer.privacyPolicy,
                           urlString: disclaimer.url)
        
        disagreeBtn.setTitle(disclaimerViewInfo.disagreeTitle, for: .normal)
        agreeBtn.setTitle(disclaimerViewInfo.agreeTitle, for: .normal)
    }
    
    private func format() {
        formatView()
        formatDisagreeBtn()
        formatAgreeBtn()
    }
    
    private func formatView() {
        holderView.layer.cornerRadius = 10.0
    }
    
    private func formatDisagreeBtn() {
        disagreeBtn.layer.cornerRadius = disagreeBtn.bounds.height/2
        disagreeBtn.layer.borderWidth = 1.0
        disagreeBtn.layer.borderColor = UIColor.disclaimerBlue.cgColor
    }
    
    private func formatAgreeBtn() {
        agreeBtn.layer.cornerRadius = disagreeBtn.bounds.height/2
    }
    
}

