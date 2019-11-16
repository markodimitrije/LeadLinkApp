//
//  RadioBtnView+Rx.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: RadioBtnView {
    var optionTxt: Binder<String> {
           return Binder.init(self.base, binding: { (view, value) in
               view.headlineText = value
           })
    }
}

extension RadioBtnView: OptionTxtUpdatable {
    var optionTxt: Binder<String> {
        return self.rx.optionTxt
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
    
}
