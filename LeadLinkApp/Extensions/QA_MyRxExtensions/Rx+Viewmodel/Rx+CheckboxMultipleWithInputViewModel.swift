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
    internal var optionsSelected: Binder<[Int]> {
        return Binder.init(self.base, binding: { (viewmodel, indexes) in
            
            let newContent = viewmodel.question.options.enumerated().filter({ (index, element) -> Bool in
                return indexes.contains(index)
            }).map({ (_, element) -> String in
                return element
            })
            
            print("CheckboxMultipleWithInputViewModel.optionsSelected = \(viewmodel)")
            
            let question = viewmodel.question // refactor!
            
            viewmodel.answer = MyAnswer.init(campaignId: question.campaignId,
                                             questionId: question.id,
                                             code: viewmodel.code,
                                             questionType: question.type.rawValue,
                                             content: newContent + ["koja vrednost?"],
                                             optionIds: indexes)
        })
    }
    
    internal var txtChanged: Binder<String> {
        return Binder.init(self.base, binding: { (viewmodel, value) in
            
            let selectedCheckboxIds = viewmodel.answer?.optionIds ?? [ ] // hard-coded, treba lastIndex
            let checkboxContent = viewmodel.answer?.content ?? [ ] // treba content na lastIndex
            
            let question = viewmodel.question
            let newAnswer = MyAnswer.init(campaignId: question.campaignId,
                                          questionId: question.id,
                                          code: viewmodel.code,
                                          questionType: question.type.rawValue,
                                          content: checkboxContent + [value],
                                          optionIds: selectedCheckboxIds)
            viewmodel.answer = newAnswer
        })
    }
    
    internal var newContent: Binder<[String]> {
        return Binder.init(self.base, binding: { (viewmodel, content) in
            
            //print("newContent for multiple check + txt = \(content)")
            
            let question = viewmodel.question // refactor!
            let indexes = content.compactMap({ text -> Int? in
                return question.options.firstIndex(of: text)
            })
            
            viewmodel.answer = MyAnswer.init(campaignId: question.campaignId,
                                             questionId: question.id,
                                             code: viewmodel.code,
                                             questionType: question.type.rawValue,
                                             content: content,
                                             optionIds: indexes)
        })
    }
}
