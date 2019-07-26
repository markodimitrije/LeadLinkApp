//
//  SelectOptionTextViewModelInputCreator.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 08/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SelectOptionTextViewModelInputCreator {
    
    var viewmodel: SelectOptionTextFieldViewModel
    
    init(viewmodel: SelectOptionTextFieldViewModel) {
        self.viewmodel = viewmodel
    }
    
    func createTxtDriver() -> Observable<MultipleStringOptions> {
        
        let headline = viewmodel.question.headlineText
        let textOptions = viewmodel.answer?.content ?? [ ]
        let text = textOptions.reduce("", {$0 + "\n" + $1})
        let desc = viewmodel.question.description ?? ""
        
        let multipleStringOptions = MultipleStringOptions.init(headline: headline,
                                                               textOptions: textOptions,
                                                               displayText: text,
                                                               placeholderText: desc)
        
        return Observable.from([multipleStringOptions])
        
    }
    
}
