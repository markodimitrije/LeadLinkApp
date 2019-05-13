//
//  CheckboxViewmodelInputCreator.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 08/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CheckboxViewmodelInputCreator {
    
    var viewmodel: CheckboxViewModel
    
    init(viewmodel: CheckboxViewModel) {
        self.viewmodel = viewmodel
    }
    
    func createTxtDrivers() -> [Driver<String>] {
        let textDrivers = viewmodel.question.options.map { (text) -> Driver<String> in
            return Observable.from([text]).asDriver(onErrorJustReturn: "")
        }
        return textDrivers
    }
    
    func createCheckboxBtnsInput(btnViews: [CheckboxView] ) -> Observable<Int> {
        
        let tags = btnViews
            .map { ($0.radioBtn.rx.tap, $0.radioBtn.tag) }
            .map { tap, tag in tap.map { tag } } // ovo zelim da je [Observable<(Int,Bool)>] da znam da li je checked ili nije
        
        return Observable.merge(tags)
        
    }
    
}
