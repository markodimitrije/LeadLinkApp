//
//  CheckboxView.swift
//  LeadLink
//
//  Created by Marko Dimitrijevic on 21/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CheckboxView: UIView, RowsStackedEqually {
    
    @IBOutlet weak var headlineLbl: UILabel!
    
    @IBOutlet weak var checkboxImageBtn: UIButton!
    @IBOutlet weak var radioBtn: UIButton!
    
    var headlineText: String? {
        get {
            return headlineLbl.text
        }
        set {
            headlineLbl.text = newValue
        }
    }
    
    private var id = 0
    private var _isOn: Bool = false
    
    private var onImg = CheckboxBtnImage().onImage
    private var offImg = CheckboxBtnImage().offImage
    
    var isOn: Bool {
        get {
            return _isOn
        }
        set {
            _isOn = newValue
            //let img = _isOn ? UIImage.init(named: "checkbox_ON") : UIImage.init(named: "checkbox_OFF")
            let img = _isOn ? onImg : offImg
            checkboxImageBtn.setBackgroundImage(img, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    convenience init(frame: CGRect, option: CheckboxOption) {
        self.init(frame: frame)
        update(option: option)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CheckboxView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
        isOn = false // draw radioBtns with empty (only outer circle)
        
    }
    
    func update(option: CheckboxOption) {
        self.id = option.id
        self.headlineText = option.text
        self.isOn = option.isOn
    }
    
}

struct CheckboxOption {
    var id = 0
    var isOn = false
    var text = ""
}
