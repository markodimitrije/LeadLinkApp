//
//  CheckboxView+Rx.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa

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
