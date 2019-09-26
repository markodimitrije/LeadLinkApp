//
//  ViewmodelFactory.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 27/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class ViewmodelFactory {

    var code: String
    
    init(code: String) {
        //print("ViewmodelFactory.imam barcode = \(code)")
        self.code = code
    }
    
    func makeViewmodel(surveyQuestion: SurveyQuestion) -> Questanable {
        
        let question = surveyQuestion.question
        let answer = surveyQuestion.answer
        
        switch surveyQuestion.question.type {
        case .textField:
            return LabelWithTextFieldViewModel.init(question: question, answer: answer, code: code)// as? TextAnswer)
        case .radioBtn:
            return RadioViewModel.init(question: question, answer: answer, code: code)
        case .checkbox:
            return CheckboxViewModel.init(question: question, answer: answer, code: code)
        case .radioBtnWithInput:
            return RadioWithInputViewModel.init(question: question, answer: answer, code: code)
        case .checkboxWithInput:
            return CheckboxWithInputViewModel.init(question: question, answer: answer, code: code)
        case .switchBtn:
            return SwitchBtnsViewModel.init(question: question, answer: answer, code: code)
        case .dropdown:
            return SelectOptionTextFieldViewModel.init(question: question, answer: answer, code: code)// as? OptionTextAnswer)
        case .textArea:
            return LabelWithTextFieldViewModel.init(question: question, answer: answer, code: code)
        case .termsSwitchBtn:
            return SwitchBtnsViewModel.init(question: question, answer: answer, code: code)
        case .checkboxMultipleWithInput:
            return CheckboxMultipleWithInputViewModel(question: question, answer: answer, code: code)
        }

    }
        
}
