//
//  LabelAndTextField+Rx.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa

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

extension Reactive where Base: LabelAndTextField {
    var titles: Binder<[String]> {
        return Binder.init(self.base, binding: { (view, value) in
            view.update(headlineText: value[0],
                        inputTxt: value[1],
                        placeholderTxt: value[2])
        })
    }
}
