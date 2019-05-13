//
//  DataBaseEmiters.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 26/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import Realm

//extension Reactive where Base: CheckboxView {
//    var answer: Binder<MyAnswer> {
//        return Binder.init(self.base, binding: { (view, value) in
//            guard let optionIds = value.optionIds else {return}
//            _ = optionIds.enumerated().map({ offset, index -> () in
//                let option = CheckboxOption(id: offset, isOn: true, text: "dafault")
//                view.update(option: option)
//            })
//        })
//    }
//}

struct Output { // treba ti side effects
    var savedAnswer: Observable<MyAnswer> // tap koji mapiras u id (btn.tag)
}
