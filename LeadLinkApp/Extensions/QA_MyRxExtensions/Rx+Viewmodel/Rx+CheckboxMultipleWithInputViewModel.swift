//
//  CheckboxMultipleWithInputViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 27/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa

// multiple single selection choice
extension Reactive where Base: CheckboxMultipleWithInputViewModel {
    
    internal var newContent: Binder<[String]> {
        return Binder.init(self.base, binding: { (viewmodel, content) in
            
            //print("newContent for multiple check + txt = \(content)")
            
            let question = viewmodel.question // refactor!
            let indexes = content.compactMap({ text -> Int? in
                return question.options.firstIndex(of: text)
            })
            
            viewmodel.answer = MyAnswer.init(question: question,
                                             code: viewmodel.code,
                                             content: content,
                                             optionIds: indexes)
        })
    }
}
