//
//  LabelBtnSwitchView+Rx.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: LabelBtnSwitchView {
    
    var optionTxt: Binder<String> {
        return Binder.init(self.base, binding: { (view, value) in
            view.labelText = value
        })
    }
    
}
