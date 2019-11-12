//
//  UITextField+ResignResponder+Rx.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
    var resignFirstResponder: Binder<Void> {
        return Binder.init(base, binding: { (base, _) in
            base.resignFirstResponder()
        })
    }
}
