//
//  LabelBtnSwitchView.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 24/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class TermsLabelBtnSwitchView: UIView, ViewWithSwitch, RowsStackedEqually {

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var linkBtn: UIButton!
    
    weak var delegate: UITextViewDelegate?
    
    private let termsVcFactory = TermsViewControllerFactory.init(appDependancyContainer: factory)
    
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
            linkBtn?.titleLabel?.numberOfLines = 0
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
    
    override func layoutSubviews() {
        updateSwitch(color: UIColor.leadLinkColor)
    }
    
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
        
        formatBorder()
        formatStackDueToDeviceType()
        
        self.addSubview(view)
        
    }
    
    private func formatBorder() {
        self.layer.borderColor = UIColor.fieldBorderGray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
    }
    
    private func formatStackDueToDeviceType() {
        if getDeviceType() == .iPad {
            stackView.axis = .horizontal
            stackView.spacing = 8.0
        } else if getDeviceType() == .iPhone {
            stackView.axis = .vertical
            stackView.spacing = -32.0
        }
    }
    
    private func termsBtnTapped() { print("show terms screen....")
        if let url = URL.init(string: Constants.TermsAndConditions.url) {
            UIApplication.shared.open(url) // hard-coded
        } else {
            if let topVC = UIApplication.topViewController() {
                let termsVC = termsVcFactory.makeVC(termsTxt: self.termsTxt)
                topVC.present(termsVC, animated: true, completion: nil)
            }
        }
        
    }
    
    private func updateSwitch(color: UIColor?) {
        switcher.onTintColor = color
    }
    
}
