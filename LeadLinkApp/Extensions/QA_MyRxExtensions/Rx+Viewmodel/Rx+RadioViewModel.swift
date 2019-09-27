//
//  Rx+RadioViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 27/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: RadioViewModel {
    internal var optionSelected: Binder<Int> {
        
        return Binder.init(self.base, binding: { (viewmodel, selectedIndex) in
            
            let newContent = viewmodel.question.options.enumerated().filter({ (ind, element) -> Bool in
                return selectedIndex == ind
            }).map({ (_, element) -> String in
                return element
            })
            
            let question = viewmodel.question
            
            viewmodel.answer = MyAnswer.init(question: question,
                                            code: viewmodel.code,
                                            content: newContent,
                                            optionIds: [selectedIndex])
        })
        
    }
}
