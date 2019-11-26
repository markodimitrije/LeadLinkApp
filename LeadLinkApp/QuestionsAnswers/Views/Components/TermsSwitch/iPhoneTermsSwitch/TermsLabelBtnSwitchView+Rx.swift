//
//  TermsLabelBtnSwitchView+Rx.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa

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
