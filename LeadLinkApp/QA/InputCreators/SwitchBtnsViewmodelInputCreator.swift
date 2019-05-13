//
//  SwitchBtnsViewmodelInputCreator.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 08/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SwitchBtnsViewmodelInputCreator {
    
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
    
    // sa svakim tap na switch, posalji snapshot svih switcheva - uradio sam da emituje samo onaj koji je fire (single data)

    func createSwitchBtnsInput(btnViews: [LabelBtnSwitchView] ) -> Observable<Int> {
        
        let allEvents = btnViews.map {($0.switcher.rx.switchTag.asObservable())}
        
        return Observable.merge(allEvents)
        
    }
    
}
