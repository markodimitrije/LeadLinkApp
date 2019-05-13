//
//  RxViewModel.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 26/03/2019.
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
            
            viewmodel.answer = MyAnswer.init(campaignId: question.campaignId,
                                             questionId: question.id,
                                             code: viewmodel.code,
                                             content: newContent,
                                             optionIds: [selectedIndex])
            })
 
    }
}

extension Reactive where Base: CheckboxViewModel {
    internal var optionSelected: Binder<[Int]> {
        return Binder.init(self.base, binding: { (viewmodel, indexes) in
            
            let newContent = viewmodel.question.options.enumerated().filter({ (index, element) -> Bool in
                return indexes.contains(index)
            }).map({ (_, element) -> String in
                return element
            })

            let question = viewmodel.question
            
            viewmodel.answer = MyAnswer.init(campaignId: question.campaignId,
                                             questionId: question.id,
                                             code: viewmodel.code,
                                             content: newContent,
                                             optionIds: indexes)
        })
    }

}

extension Reactive where Base: RadioWithInputViewModel {
    internal var optionSelected: Binder<Int> {
        return Binder.init(self.base, binding: { (viewmodel, index) in
            let optionTxt = viewmodel.question.options[index]
            let question = viewmodel.question
            let newAnswer = MyAnswer.init(campaignId: question.campaignId,
                                          questionId: question.id,
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
            let newAnswer = MyAnswer.init(campaignId: question.campaignId,
                                          questionId: question.id,
                                          code: viewmodel.code,
                                          content: [value],
                                          optionIds: [lastIndex])
            viewmodel.answer = newAnswer
        })
    }
}

// single selection choice
extension Reactive where Base: CheckboxWithInputViewModel {
    internal var optionSelected: Binder<Int> {
        return Binder.init(self.base, binding: { (viewmodel, index) in
            let optionTxt = viewmodel.question.options[index]
            let question = viewmodel.question
            let newAnswer = MyAnswer.init(campaignId: question.campaignId,
                                          questionId: question.id,
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
            let newAnswer = MyAnswer.init(campaignId: question.campaignId,
                                        questionId: question.id,
                                        code: viewmodel.code,
                                        content: [value],
                                        optionIds: [lastIndex])
            viewmodel.answer = newAnswer
        })
    }
}

extension Reactive where Base: SwitchBtnsViewModel {
    internal var optionSelected: Binder<[Int]> { // javlja ti koji tag (redni br switch-a je tapped)
        return Binder.init(self.base, binding: { (viewmodel, indexes) in
            
            let newContent = viewmodel.question.options.enumerated().filter({ (index, element) -> Bool in
                return indexes.contains(index)
            }).map({ (_, element) -> String in
                return element
            })
            let question = viewmodel.question
            let newAnswer = MyAnswer.init(campaignId: question.campaignId,
                                          questionId: question.id,
                                          code: viewmodel.code,
                                          content: newContent,
                                          optionIds: indexes)
            viewmodel.answer = newAnswer
        })
    }
}

extension Reactive where Base: LabelWithTextFieldViewModel {
    internal var answer: Binder<String?> {
        return Binder.init(self.base, binding: { (viewmodel, text) in

            let question = viewmodel.question
            
            let newAnswer = MyAnswer.init(campaignId: question.campaignId,
                                          questionId: question.id,
                                          code: viewmodel.code,
                                          content: [text ?? ""],
                                          optionIds: nil)
                                                         
            viewmodel.answer = newAnswer
        })
    }
}

extension Reactive where Base: SelectOptionTextFieldViewModel {
    internal var optionsSelected: Binder<[String]> {
        return Binder.init(self.base, binding: { (viewmodel, content) in
            
            let question = viewmodel.question
            let newAnswer = MyAnswer.init(campaignId: question.campaignId,
                                          questionId: question.id,
                                          code: viewmodel.code,
                                          content: content,
                                          optionIds: [ ])
            
            viewmodel.answer = newAnswer
        })
    }
}
