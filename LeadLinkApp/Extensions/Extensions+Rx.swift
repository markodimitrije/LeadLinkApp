//
//  Extensions+Rx.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 13/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    /// Bindable sink for `enabled` property.
    public var dismissKeyboard: Binder<Void> {
        return Binder(self.base) { control, value in
            self.base.view.endEditing(true)
        }
    }
}

extension Reactive where Base: UITextField {
    var resignFirstResponder: Binder<Void> {
        return Binder.init(base, binding: { (base, _) in
            base.resignFirstResponder()
        })
    }
}


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
    
    var labelTxt: Binder<String> {
        return Binder.init(self.base, binding: { (view, value) in
            view.labelText = value
        })
    }
    
    var linkBtnTxt: Binder<String> {
        return Binder.init(self.base, binding: { (view, value) in
            view.linkBtnText = value
        })
    }
    
    var termsTxt: Binder<String> {
        return Binder.init(self.base, binding: { (view, value) in
            view.termsTxt = value
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
    
    var update: Binder<(headline: String, text: String, placeholderTxt: String)> {
        return Binder.init(self.base, binding: { (view, value) in
            view.update(headlineText: value.headline,
                        inputTxt: value.text,
                        placeholderTxt: value.placeholderTxt)
        })
    }
    
}
