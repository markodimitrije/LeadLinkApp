//
//  CheckboxViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CheckboxViewModel: NSObject, ViewModelType, Questanable, Answerable {
    
    var question: PresentQuestion
    var answer: MyAnswer?
    var code: String = ""
    
    init(question: PresentQuestion, answer: MyAnswer?, code: String) {
        self.question = question
        self.answer = answer
        self.code = code
    }
    
    struct Input {
        var ids: Observable<[Int]>
        var answer: MyAnswer?
    }
    
    struct Output { // treba ti side effects
        var ids: Observable<[Int]> // tap koji mapiras u id (btn.tag)
    }
    
    func transform(input: Input) -> Output { // ovo je bas bezveze... razumi kako radi...
        
        let resulting = Observable.merge(Observable.of(answer?.optionIds ?? [ ]), input.ids)
        
        let withAnswer = (answer != nil) ? resulting : input.ids
        
        let output = Output.init(ids: withAnswer)
        
        return output
    }
    
    let bag = DisposeBag()
    
}
