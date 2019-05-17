//
//  LabelBtnSwitchView.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 24/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class TermsLabelBtnSwitchView: UIView {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var linkBtn: UIButton!
    
    var labelText: String? {
        get {
            return label?.text
        }
        set {
            label?.text = newValue
        }
    }
    
    var linkBtnText: String? {
        get {
            return linkBtn?.titleLabel?.text
        }
        set {
            linkBtn?.titleLabel?.text = newValue
        }
    }

    var switchIsOn: Bool {
        get {
            return switcher.isOn
        }
        set {
            switcher.isOn = newValue
        }
    }
    
    var desc: String? // zapamti state koji ti je neko poslao
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib() // ne zaboravi OVO !
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    convenience init(frame: CGRect, termsInfo: TermsAndConditionsInfo) {
        self.init(frame: frame)
        update(termsAndConditionsInfo: termsInfo)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TermsLabelBtnSwitchView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
    }
    
    func update(termsAndConditionsInfo termsInfo: TermsAndConditionsInfo) {
        self.labelText = termsInfo.switchInfo.text
        self.switchIsOn = termsInfo.switchInfo.switchIsOn
        self.desc = termsInfo.switchInfo.desc
        self.linkBtnText = termsInfo.linkText
    }
    
}

struct TermsAndConditionsInfo {
    var switchInfo: SwitchInfo
    var linkText: String
}

