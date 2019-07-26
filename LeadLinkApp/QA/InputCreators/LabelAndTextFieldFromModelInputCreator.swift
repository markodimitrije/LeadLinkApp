//
//  LabelAndTextFieldFromModelInputCreator.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 08/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LabelAndTextFieldFromModelInputCreator {
    
    var viewmodel: LabelWithTextFieldViewModel
    
    init(viewmodel: LabelWithTextFieldViewModel) {
        self.viewmodel = viewmodel
    }
    
    func createTxtDriver() -> Observable<(String, String, String)> {
        
        let headline = viewmodel.question.headlineText
        let text = (viewmodel.answer?.content ?? [ ]).reduce("", {$0 + "\n" + $1}).trimmingCharacters(in: CharacterSet.init(charactersIn: "\n")) // remove enter on start end end
        let placeholderTxt = viewmodel.question.description ?? ""
        return Observable.from([(headline, text, placeholderTxt)])
        
    }
    
    func createBarcodeTxtDriver() -> Observable<(String, String, String)> {
        
        let headline = viewmodel.question.headlineText
        let text = viewmodel.code
        let placeholderTxt = ""
        return Observable.from([(headline, text, placeholderTxt)])
        
    }
    
}
