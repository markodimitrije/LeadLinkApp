//
//  LabelAndPhoneTextFieldFromModelInputCreator.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 06/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa

class LabelAndPhoneTextFieldFromModelInputCreator {
    
    var viewmodel: LabelWithPhoneTextFieldViewModel
    
    init(viewmodel: LabelWithPhoneTextFieldViewModel) {
        self.viewmodel = viewmodel
    }
    
    func createTxtDriver() -> Observable<[String]> {
        
        let headline = viewmodel.question.headlineText
        let text = (viewmodel.answer?.content ?? [ ]).reduce("", {$0 + "\n" + $1}).trimmingCharacters(in: CharacterSet.init(charactersIn: "\n")) // remove enter on start end end
        let placeholderTxt = viewmodel.question.description
        
        return Observable.from(optional: [headline, text, placeholderTxt])

    }
    
}
