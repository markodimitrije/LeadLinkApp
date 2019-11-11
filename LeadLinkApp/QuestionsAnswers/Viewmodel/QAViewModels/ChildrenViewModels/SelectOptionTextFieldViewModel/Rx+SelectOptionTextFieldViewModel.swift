//
//  RxViewModel.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 26/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//


import RxSwift
import RxCocoa

extension Reactive where Base: SelectOptionTextFieldViewModel {
    internal var optionsSelected: Binder<[String]> {
        return Binder.init(self.base, binding: { (viewmodel, content) in
            
            let question = viewmodel.question
            let newAnswer = MyAnswer.init(question: question,
                                          code: viewmodel.code,
                                          content: content,
                                          optionIds: [ ])
            
            viewmodel.answer = newAnswer
        })
    }
}
