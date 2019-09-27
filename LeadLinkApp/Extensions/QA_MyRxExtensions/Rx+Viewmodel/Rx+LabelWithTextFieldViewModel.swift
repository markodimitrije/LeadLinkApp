//
//  Rx+LabelWithTextFieldViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 27/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: LabelWithTextFieldViewModel {
    internal var answer: Binder<String?> {
        return Binder.init(self.base, binding: { (viewmodel, text) in
            
            let question = viewmodel.question
            
            let newAnswer = MyAnswer.init(question: question,
                                          code: viewmodel.code,
                                          content: [text ?? ""],
                                          optionIds: nil)
            
            viewmodel.answer = newAnswer
        })
    }
}
