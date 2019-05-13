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
    
    var isOn: Bool {
        get {
            return _isOn
        }
        set {
            _isOn = newValue
            let img = _isOn ? UIImage.init(named: "checkbox_ON") : UIImage.init(named: "checkbox_OFF")
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


extension Reactive where Base: CheckboxView {
    
    var btnOnImg: UIImage? {
        return UIImage.init(named: "checkbox_ON")
    }
    
    var btnOffImg: UIImage?  {
        return UIImage.init(named: "checkbox_OFF")
    }
    
    var isOn: Binder<Bool> {
        return Binder.init(self.base, binding: { (view, value) in
            let image = value ? self.btnOnImg : self.btnOffImg
            view.checkboxImageBtn.setBackgroundImage(image, for: .normal)
        })
    }
    
}
