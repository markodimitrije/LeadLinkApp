//
//  Rx+CheckboxWithInputViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 27/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa

// single selection choice
extension Reactive where Base: CheckboxWithInputViewModel {
    internal var optionSelected: Binder<Int> {
        return Binder.init(self.base, binding: { (viewmodel, index) in
            let optionTxt = viewmodel.question.options[index]
            let question = viewmodel.question
            let newAnswer = MyAnswer.init(question: question,
                                          code: viewmodel.code,
                                          content: [optionTxt],
                                          optionIds: [index])
            viewmodel.answer = newAnswer
        })
    }
    internal var txtChanged: Binder<String> {
        return Binder.init(self.base, binding: { (viewmodel, value) in
            let options = viewmodel.question.options
            guard let lastOption = options.last,
                let lastIndex = options.lastIndex(of: lastOption) else {return}
            let question = viewmodel.question
            let newAnswer = MyAnswer.init(question: question,
                                          code: viewmodel.code,
                                          content: [value],
                                          optionIds: [lastIndex])
            viewmodel.answer = newAnswer
        })
    }
}
