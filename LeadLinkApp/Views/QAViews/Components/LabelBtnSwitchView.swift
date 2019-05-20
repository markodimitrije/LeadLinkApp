//
//  LabelBtnSwitchView.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 24/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class LabelBtnSwitchView: UIView, ViewWithSwitch {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    var labelText: String? {
        get {
            return label?.text
        }
        set {
            label?.text = newValue
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
    
    convenience init(frame: CGRect, switchInfo: SwitchInfo) {
        self.init(frame: frame)
        update(switchInfo: switchInfo)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LabelBtnSwitchView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
    }
    
    func update(switchInfo: SwitchInfo) {
        self.labelText = switchInfo.text
        self.switchIsOn = switchInfo.switchIsOn
        self.desc = switchInfo.desc
    }
    
}

struct SwitchInfo {
    var text: String
    var desc: String?
    var switchIsOn = false
}
