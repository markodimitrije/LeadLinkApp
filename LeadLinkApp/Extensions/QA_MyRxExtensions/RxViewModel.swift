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
            
            viewmodel.answer = MyAnswer.init(campaignId: question.campaignId, // refactor !!!
                                             questionId: question.id,
                                             code: viewmodel.code,
                                             questionType: question.type.rawValue,
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
                                             questionType: question.type.rawValue,
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
                                          questionType: question.type.rawValue,
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
                                          questionType: question.type.rawValue,
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
                                          questionType: question.type.rawValue,
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
                                        questionType: question.type.rawValue,
                                        content: [value],
                                        optionIds: [lastIndex])
            viewmodel.answer = newAnswer
        })
    }
}

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
                                          questionType: question.type.rawValue,
                                          content: newContent,
                                          optionIds: indexes)
            //print("extension Reactive where Base: SwitchBtnsViewModel")
            //print("newAnswer = \(newAnswer)")
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
                                          questionType: question.type.rawValue,
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
                                          questionType: question.type.rawValue,
                                          content: content,
                                          optionIds: [ ])
            
            viewmodel.answer = newAnswer
        })
    }
}
