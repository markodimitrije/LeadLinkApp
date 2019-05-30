//
//  RadioWithInputViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RadioWithInputViewModel: NSObject, ViewModelType, Questanable {
    
    var question: PresentQuestion
    var answer: MyAnswer?
    var code: String = ""
    
    init(question: PresentQuestion, answer: MyAnswer?, code: String) {
        self.question = question
        self.answer = answer
        self.code = code
    }
    
    struct Input {
        var id: Observable<Int>
        var optionTxt: Observable<String?>
        var answer: MyAnswer?
    }
    
    struct Output { // treba ti side effects
        var id: Observable<Int> // tap koji mapiras u id (btn.tag)
        var optionTxt: Observable<String?>
    }
    
    func transform(input: Input) -> Output { // ovo je bas bezveze... razumi kako radi...
        
        let output = Output.init(id: input.id, optionTxt: input.optionTxt)
        
        return output
    }
    
    private var bag = DisposeBag()
}
