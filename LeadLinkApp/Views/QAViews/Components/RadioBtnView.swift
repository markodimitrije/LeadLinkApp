//
//  RadioBtnsView.swift
//  LeadLink
//
//  Created by Marko Dimitrijevic on 21/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class RadioBtnView: UIView, RowsStackedEqually { // RowsStackedEqually hocu da su redovi uvek jednakih height..
    
    @IBOutlet weak var headlineLbl: UILabel!
    
    @IBOutlet weak var radioImageBtn: UIButton!
    @IBOutlet weak var radioBtn: UIButton!
    
    @IBAction func radioBtnTapped(_ sender: UIButton) {
        //delegate?.radioBtnTapped(index: sender.tag)
    }
    
    var counter: Int = 0
    
    // ovde moze da se zakaci listener // mnogo je bolje sa observables...
    
    //weak var delegate: RadioBtnListener?
    
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
    
    var radioBtnOnImg = UIImage.init(named: "radioBtn_ON")
    var radioBtnOffImg = UIImage.init(named: "radioBtn_OFF")
    
    var isOn: Bool {
        get {
            return _isOn
        }
        set {
            _isOn = newValue
            let img = _isOn ? radioBtnOnImg : radioBtnOffImg
            radioImageBtn.setBackgroundImage(img, for: .normal)
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
    
    convenience init(frame: CGRect, option: RadioBtnOption) {
        self.init(frame: frame)
        update(option: option)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RadioBtnView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
    }
    
    func update(option: RadioBtnOption) {
        self.id = option.id
        self.headlineText = option.text
        self.isOn = option.isOn
    }
    
    func set(logic: Bool) {
        self.isOn = logic
    }
    
}

struct RadioBtnOption {
    var id = 0
    var isOn = false
    var text = ""
}

//protocol RadioBtnListener: class { // ovo ukloni, koristim RX !
//    func radioBtnTapped(index: Int)
//}

extension Reactive where Base: RadioBtnView {

    var radioBtnOnImg: UIImage? {
        return UIImage.init(named: "radioBtn_ON")
    }
    
    var radioBtnOffImg: UIImage?  {
        return UIImage.init(named: "radioBtn_OFF")
    }
    
    var isOn: Binder<Bool> {
        return Binder.init(self.base, binding: { (view, value) in
            let image = value ? self.radioBtnOnImg : self.radioBtnOffImg
            view.radioImageBtn.setBackgroundImage(image, for: .normal)
        })
    }
    
    var optionTxt: Binder<String> {
        return Binder.init(self.base, binding: { (view, value) in
            view.headlineText = value
        })
    }

}

extension Reactive where Base: LabelBtnSwitchView {
    
    var optionTxt: Binder<String> {
        return Binder.init(self.base, binding: { (view, value) in
            view.labelText = value
        })
    }
    
}

extension Reactive where Base: TermsLabelBtnSwitchView {
    
    var optionTxt: Binder<String> {
        return Binder.init(self.base, binding: { (view, value) in
            view.labelText = value
        })
    }
    
}

extension Reactive where Base: LabelAndTextField {
    
    var headlineTxt: Binder<String> {
        return Binder.init(self.base, binding: { (view, value) in
            view.headlineTxt = value
        })
    }

    var inputTxt: Binder<String> {
        return Binder.init(self.base, binding: { (view, value) in
            view.inputTxt = value
        })
    }
    
    var update: Binder<(headline: String, text: String)> {
        return Binder.init(self.base, binding: { (view, value) in
            view.update(headlineText: value.headline, inputTxt: value.text)
        })
    }
    
}
