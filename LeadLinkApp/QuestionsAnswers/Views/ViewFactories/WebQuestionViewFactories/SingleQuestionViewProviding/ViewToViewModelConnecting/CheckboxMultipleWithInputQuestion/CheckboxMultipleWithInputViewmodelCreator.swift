//
//  CheckboxMultipleWithInputViewmodelCreator.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 26/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CheckboxMultipleWithInputViewmodelCreator {
    
    var viewmodel: CheckboxMultipleWithInputViewModel
    var textDrivers: [Driver<String>]
    var checkboxBtnsInput: Observable<Int>
    
    init(viewmodel: CheckboxMultipleWithInputViewModel, checkboxBtnViews: [CheckboxView]) {
        
        func createTxtDrivers() -> [Driver<String>] {
            
            var answerTxt: String? { return viewmodel.answer?.content.last }
            var options: [String] {return viewmodel.question.options}
            
            let anserIsOptionTxt = (answerTxt != nil) ? !options.contains(answerTxt!) : nil
            let optionTxt = (anserIsOptionTxt == nil) ? "" : (anserIsOptionTxt != nil && anserIsOptionTxt!) ? (answerTxt!) : ""
            
            let allOptions = options + [optionTxt]
            
            let textDrivers = allOptions.map { (text) -> Driver<String> in
                return Observable.from([text]).asDriver(onErrorJustReturn: "")
            }
            return textDrivers
        }
        
        func createChecboxMultipleBtnsInput(btnViews: [CheckboxView] ) -> Observable<Int> {
            
            let tags = btnViews
                .map { ($0.radioBtn.rx.tap, $0.radioBtn.tag) }
                .map { tap, tag in tap.map { tag } } // ovo zelim da je [Observable<(Int,Bool)>] da znam da li je checked ili nije
            
            return Observable.merge(tags)
            
        }
        
        self.viewmodel = viewmodel
        self.textDrivers = createTxtDrivers()
        self.checkboxBtnsInput = createChecboxMultipleBtnsInput(btnViews: checkboxBtnViews)
    }
    
}
