//
//  TermsSwitchInputCreator.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 20/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa

class TermsSwitchBtnsViewmodelInputCreator {
    
    var viewmodel: SwitchBtnsViewModel
    
    init(viewmodel: SwitchBtnsViewModel) {
        self.viewmodel = viewmodel
    }
    
    func createTxtDrivers() -> [Driver<String>] {
        let textDrivers = viewmodel.question.options.map { (text) -> Driver<String> in
            return Observable.from([text]).asDriver(onErrorJustReturn: "")
        }
        return textDrivers
    }

    func createSwitchBtnsInput(btnViews: [TermsLabelBtnSwitchView] ) -> Observable<Int> {
        
        let allEvents = btnViews.map {($0.switcher.rx.switchTag.asObservable())}
        
        return Observable.merge(allEvents)
        
    }
    
}
