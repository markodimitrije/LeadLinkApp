//
//  UIViewController+DismissKeyboard+Rx.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
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
