//
//  Rx+CheckboxViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 27/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: CheckboxViewModel {
    internal var optionSelected: Binder<[Int]> {
        return Binder.init(self.base, binding: { (viewmodel, indexes) in
            
            let newContent = viewmodel.question.options.enumerated().filter({ (index, element) -> Bool in
                return indexes.contains(index)
            }).map({ (_, element) -> String in
                return element
            })
            
            let question = viewmodel.question
            
            viewmodel.answer = MyAnswer.init(question: question,
                                             code: viewmodel.code,
                                             content: newContent,
                                             optionIds: indexes)
        })
    }
    
}
