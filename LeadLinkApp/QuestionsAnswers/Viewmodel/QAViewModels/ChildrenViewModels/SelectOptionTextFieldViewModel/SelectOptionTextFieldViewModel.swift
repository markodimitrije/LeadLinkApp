//
//  SelectOptionTextFieldViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol Questanable {
    var question: QuestionProtocol {get set}
    var code: String {get set}
}

protocol Answerable {
    var answer: MyAnswerProtocol? {get set}
}

class SelectOptionTextFieldViewModel: NSObject, ViewModelType, Questanable, Answerable {
    var question: QuestionProtocol
    var answer: MyAnswerProtocol?
    var code: String = ""
    
    init(question: QuestionProtocol, answer: MyAnswerProtocol?, code: String) {
        self.question = question
        self.answer = answer
        self.code = code
    }
    
    struct Input {
        var content: Observable<[String]> // ovo su izabrane opcije, npr ["ita", "bra", "usa"...]
        var answer: MyAnswerProtocol?
    }
    
    struct Output { // treba ti side effects
        var content: Observable<[String]> // txt koji mapiras
    }
    
    func transform(input: Input) -> Output {
        
        let withAnswer = Observable.merge(Observable.of(answer?.content ?? [ ]), input.content)
        
        return Output.init(content: withAnswer)
    }
    
    private var bag = DisposeBag()
    
}
