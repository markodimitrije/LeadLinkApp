//
//  LabelAndPhoneTxtField+Rx.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 15/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: LabelAndPhoneTextField {
    var titles: Binder<[String]> {
        return Binder.init(self.base, binding: { (view, value) in
            view.update(headlineText: value[0],
                        inputTxt: value[1],
                        placeholderTxt: value[2])
        })
    }
}
