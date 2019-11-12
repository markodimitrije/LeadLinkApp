//
//  RadioWithInputViewmodelInputCreator.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 08/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RadioWithInputViewmodelInputCreator {
    
    var viewmodel: RadioWithInputViewModel
    var textDrivers: [Driver<String>]
    var radioBtnsInput: Observable<Int>
    
    init(viewmodel: RadioWithInputViewModel, radioBtnViews: [RadioBtnView]) {
        
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
        func createRadioBtnsInput(btnViews: [RadioBtnView] ) -> Observable<Int> {
            
            let tags = btnViews
                .map { ($0.radioBtn.rx.tap, $0.radioBtn.tag) }
                .map { tap, tag in tap.map { tag } } // ovo zelim da je [Observable<(Int,Bool)>] da znam da li je checked ili nije
            
            return Observable.merge(tags)
            
        }
        
        self.viewmodel = viewmodel
        self.textDrivers = createTxtDrivers()
        self.radioBtnsInput = createRadioBtnsInput(btnViews: radioBtnViews)
        
    }
    
}
