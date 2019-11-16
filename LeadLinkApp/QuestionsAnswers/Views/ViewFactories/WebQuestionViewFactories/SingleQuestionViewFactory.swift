//
//  SingleQuestionViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

protocol QuestionViewCreating {
    func makeViewStacker(surveyQuestion: SurveyQuestion, frame: CGRect, viewmodel: Questanable) -> UIView?
}

class SingleQuestionViewFactory: QuestionViewCreating {
    
    private var sameComponentsFactory: SameComponentsFactory
    private var questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory
    private var bag: DisposeBag
    private var delegate: UITextViewDelegate?
    
    private var helperFactories: HelperFactories
    
    init(sameComponentsFactory: SameComponentsFactory, questionViewHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory, bag: DisposeBag, delegate: UITextViewDelegate?) {
        
        self.sameComponentsFactory = sameComponentsFactory
        self.questionViewWithHeadlineLabelFactory = questionViewHeadlineLabelFactory
        self.bag = bag
        self.delegate = delegate
        
        self.helperFactories = HelperFactories(sameComponentsFactory: sameComponentsFactory, questionViewWithHeadlineLabelFactory: questionViewWithHeadlineLabelFactory, bag: bag, delegate: delegate)
        
    }
    func makeViewStacker(surveyQuestion: SurveyQuestion, frame: CGRect, viewmodel: Questanable) -> UIView? {
        
        let questionType = surveyQuestion.question.type
        let answer = surveyQuestion.answer
        let question = surveyQuestion.question

        switch questionType {
        case .radioBtn: // OK

            return ViewStackerForRadioQuestion(helperFactories: helperFactories, surveyQuestion: surveyQuestion, viewmodel: viewmodel).resultView

        case .radioBtnWithInput:  // ERROR !!! BUG
            
            return ViewStackerForRadioWithInputQuestion(helperFactories: helperFactories, surveyQuestion: surveyQuestion, viewmodel: viewmodel).resultView
            
        case .checkbox: // OK
            
            return ViewStackerForCheckboxQuestion(helperFactories: self.helperFactories, question: question, answer: answer, frame: frame, viewmodel: viewmodel).resultView
            
        case .checkboxSingleWithInput: // OK
            
            return ViewStackerForCheckboxWithInputQuestion(helperFactories: self.helperFactories, question: question, answer: answer, frame: frame, viewmodel: viewmodel).resultView
            
        case .switchBtn: // OK
            return ViewStackerForSwitchQuestion(helperFactories: self.helperFactories, question: question, answer: answer, frame: frame, viewmodel: viewmodel).resultView
            
        case .textField: // OK
            
            if let option = question.options.first, option == "phone" {
                return ViewStackerForPhoneTextFieldQuestion(helperFactories: self.helperFactories, question: question, answer: answer, frame: frame, viewmodel: viewmodel).resultView
            } else {
                return ViewStackerForTextFieldQuestion(helperFactories: self.helperFactories, question: question, answer: answer, frame: frame, viewmodel: viewmodel).resultView
            }
            
        case .textArea:
            
            return ViewStackerForTextAreaQuestion(helperFactories: self.helperFactories, question: question, answer: answer, frame: frame, viewmodel: viewmodel).resultView
            
        case .dropdown:
            
            return ViewStackerForDropdownQuestion(helperFactories: self.helperFactories, question: question, answer: answer, frame: frame, viewmodel: viewmodel).resultView
            
        case .termsSwitchBtn:
            
            return ViewStackerForTermsSwitchQuestion(helperFactories: self.helperFactories, question: question, answer: answer, frame: frame, viewmodel: viewmodel).resultView
            
        case .checkboxMultipleWithInput:
            
            return  ViewStackerForCheckboxMultipleWithInputQuestion(helperFactories: self.helperFactories, question: question, answer: answer, frame: frame, viewmodel: viewmodel).resultView
            
        }
        
    }
    
}