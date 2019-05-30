//
//  LabelBtnSwitchView.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 24/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class TermsLabelBtnSwitchView: UIView, ViewWithSwitch, RowsStackedEqually {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var linkBtn: UIButton!
    
    @IBAction func termsTapped(_ sender: UIButton) {
        termsBtnTapped()
    }
    
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
            //linkBtn?.titleLabel?.text = newValue
            linkBtn?.setTitle(newValue, for: .normal)
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
    
    var termsTxt: String? // zapamti state koji ti je neko poslao
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib() // ne zaboravi OVO !
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TermsLabelBtnSwitchView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
    }
    
    private func termsBtnTapped() { print("show terms screen....")
        if let topVC = UIApplication.topViewController() {
            let factory = AppDependencyContainer()
            let termsVC = factory.makeTermsVC(termsTxt: self.termsTxt)
            topVC.present(termsVC, animated: true, completion: nil)
        }
    }
    
}

