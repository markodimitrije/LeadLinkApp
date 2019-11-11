//
//  Rx+SwitchBtnsViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 27/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: SwitchBtnsViewModel {
    internal var optionSelected: Binder<[Int]> { // javlja ti koji tag (redni br switch-a je tapped)
        return Binder.init(self.base, binding: { (viewmodel, indexes) in
            
            let newContent = viewmodel.question.options.enumerated().filter({ (index, element) -> Bool in
                return indexes.contains(index)
            }).map({ (_, element) -> String in
                return element
            })
            let question = viewmodel.question
            let newAnswer = MyAnswer.init(question: question,
                                          code: viewmodel.code,
                                          content: newContent,
                                          optionIds: indexes)
            viewmodel.answer = newAnswer
        })
    }
}
