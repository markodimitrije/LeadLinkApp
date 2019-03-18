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

extension Reactive where Base: QRcodeView {
    var dismiss: Binder<Void> {
        return Binder.init(base, binding: { (base, _) in
            base.isHidden = true
        })
    }
}


extension Reactive where Base: UITextField {
    var dismiss: Binder<Void> {
        return Binder.init(base, binding: { (base, _) in
            base.resignFirstResponder()
        })
    }
}
