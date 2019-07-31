//
//  OCP.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class RadioBtnsQuestionView: QuestionViewMaking {
    private var questionViewFactory: QuestionViewFactory
    required init(questionViewFactory: QuestionViewFactory) {
        self.questionViewFactory = questionViewFactory
    }
    
    typealias ViewModel = RadioViewModel
    typealias View = RadioBtnView
    
    func hookUp(btnViews: [View], viewmodel: ViewModel, bag: DisposeBag, selector: Selector?) {
        
    }
}


extension LabelWithTxtViewFactory: QuestionViewFactory {
    func getViewStackerAndItsViews(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (ViewStacker, [RadioBtnView]) {
        return (ViewStacker.init(), [])
    }
    
}

protocol QuestionViewFactory {
    func getViewStackerAndItsViews(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (ViewStacker, [RadioBtnView])
}


protocol QuestionViewCreating {
    func makeViewStacker(question: SurveyQuestion, answer: Answering?, frame: CGRect, viewmodel: Questanable) -> UIView?
}

class MyQuestionViewFactory: QuestionViewCreating {
    var sameComponentsFactory: SameComponentsFactory
    var questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory
    var bag: DisposeBag
    var delegate: UITextViewDelegate?
    
    private var helperFactories: HelperFactories
    
    init(sameComponentsFactory: SameComponentsFactory, questionViewHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory, bag: DisposeBag, delegate: UITextViewDelegate?) {
        self.sameComponentsFactory = sameComponentsFactory
        self.questionViewWithHeadlineLabelFactory = questionViewHeadlineLabelFactory
        self.bag = bag
        self.delegate = delegate
        
        helperFactories = HelperFactories(sameComponentsFactory: sameComponentsFactory, questionViewWithHeadlineLabelFactory: questionViewWithHeadlineLabelFactory, bag: bag, delegate: delegate)
        
    }
    func makeViewStacker(question: SurveyQuestion, answer: Answering?, frame: CGRect, viewmodel: Questanable) -> UIView? {
        
        let questionType = question.question.type
        let question = question.question

        switch questionType {
        case .radioBtn: // OK

            return ViewStackerForRadioQuestion(helperFactories: helperFactories, question: question, answer: answer, frame: frame, viewmodel: viewmodel).resultView

        case .radioBtnWithInput:  // ERROR !!! BUG
            
//            return viewStackerForRadioWithInputQuestion(question: question,
//                                                        answer: answer,
//                                                        frame: frame)
            return ViewStackerForRadioWithInputQuestion(helperFactories: helperFactories, question: question, answer: answer, frame: frame, viewmodel: viewmodel).resultView
            
        case .checkbox: // OK
            
            return ViewStackerForCheckboxQuestion(helperFactories: self.helperFactories, question: question, answer: answer, frame: frame, viewmodel: viewmodel).resultView
            
        case .checkboxWithInput: // OK
            
            return ViewStackerForCheckboxWithInputQuestion(helperFactories: self.helperFactories, question: question, answer: answer, frame: frame, viewmodel: viewmodel).resultView
            
        case .switchBtn: // OK
            return ViewStackerForSwitchQuestion(helperFactories: self.helperFactories, question: question, answer: answer, frame: frame, viewmodel: viewmodel).resultView
            
        default: break
        }
        return nil
    }
    
    private func viewStackerForRadioQuestion(question: PresentQuestion,
                                             answer: Answering?,
                                             frame: CGRect) -> UIView {
        
        let radioFactory = RadioBtnsViewFactory.init(sameComponentsFactory: sameComponentsFactory, questionViewWithHeadlineLabelFactory: questionViewWithHeadlineLabelFactory, bag: bag, delegate: delegate)
        let result: (UIView, [RadioBtnView]) = radioFactory.getRadioBtnsView(question: question, answer: answer, frame: frame)
        let binder = StackViewToRadioBtnsViewModelBinder.init()
        let vm = RadioViewModel(question: question, answer: answer as? MyAnswer, code: "bak") // hard-coded
        binder.hookUp(btnViews: result.1, viewmodel: vm, bag: bag)
        return result.0
        
    }
    
    private func viewStackerForRadioWithInputQuestion(question: PresentQuestion,
                                                      answer: Answering?,
                                                      frame: CGRect) -> UIView {
        
        let radioFactory = RadioBtnsWithInputViewFactory.init(sameComponentsFactory: sameComponentsFactory, questionViewWithHeadlineLabelFactory: questionViewWithHeadlineLabelFactory, bag: bag, delegate: delegate)
        let result: (UIView, [UIView]) = radioFactory.getRadioBtnsWithInputView(question: question, answer: answer, frame: frame)
        let binder = StackViewToRadioBtnsWithInputViewModelBinder.init()
        let vm = RadioWithInputViewModel(question: question, answer: answer as? MyAnswer, code: "123") // hard-coded
        binder.hookUp(btnViews: result.1, viewmodel: vm, bag: bag)
        
        return result.0
        
    }
    
}

protocol QuestionViewProviding {
    var resultView: UIView {get set}
}

class ViewStackerForRadioQuestion: QuestionViewProviding {
    
    private var helperFactories: HelperFactories
    var resultView: UIView
    
    init(helperFactories: HelperFactories, question: PresentQuestion, answer: Answering?, frame: CGRect, viewmodel: Questanable) {
    
        self.helperFactories = helperFactories
        
        let radioFactory = RadioBtnsViewFactory.init(
            sameComponentsFactory: helperFactories.sameComponentsFactory,
            questionViewWithHeadlineLabelFactory: helperFactories.questionViewWithHeadlineLabelFactory,
            bag: helperFactories.bag,
            delegate: helperFactories.delegate)
        
        let result: (UIView, [RadioBtnView]) = radioFactory.getRadioBtnsView(question: question, answer: answer, frame: frame)
        
        let binder = StackViewToRadioBtnsViewModelBinder.init()
        binder.hookUp(btnViews: result.1,
                      viewmodel: viewmodel as! RadioViewModel,
                      bag: helperFactories.bag)
        
        self.resultView = result.0
        
        
        
        
    }
}

class ViewStackerForCheckboxQuestion: QuestionViewProviding {
    
    private var helperFactories: HelperFactories
    var resultView: UIView
    
    init(helperFactories: HelperFactories, question: PresentQuestion, answer: Answering?, frame: CGRect, viewmodel: Questanable) {
        
        self.helperFactories = helperFactories
        
        let factory = CheckboxBtnsViewFactory.init(
            sameComponentsFactory: helperFactories.sameComponentsFactory,
            questionViewWithHeadlineLabelFactory: helperFactories.questionViewWithHeadlineLabelFactory,
            bag: helperFactories.bag,
            delegate: helperFactories.delegate)
        
        let result: (UIView, [CheckboxView]) = factory.getCheckboxBtnsView(question: question, answer: answer, frame: frame)
        let binder = StackViewToCheckboxBtnsViewModelBinder.init()

        binder.hookUp(btnViews: result.1,
                      viewmodel: viewmodel as! CheckboxViewModel,
                      bag: helperFactories.bag)
        
        self.resultView = result.0
        
    }
}









class ViewStackerForRadioWithInputQuestion: QuestionViewProviding {
    
    private var helperFactories: HelperFactories
    var resultView: UIView
    
    init(helperFactories: HelperFactories, question: PresentQuestion, answer: Answering?, frame: CGRect, viewmodel: Questanable) {
        
        self.helperFactories = helperFactories
        
        let factory = RadioBtnsWithInputViewFactory.init(
            sameComponentsFactory: helperFactories.sameComponentsFactory,
            questionViewWithHeadlineLabelFactory: helperFactories.questionViewWithHeadlineLabelFactory,
            bag: helperFactories.bag,
            delegate: helperFactories.delegate)
        
//        let result: (UIView, [UIView]) = factory.getRadioBtnsWithInputView(question: question, answer: answer, frame: frame)
        let result: (UIView, [UIView]) = factory.getRadioBtnsWithInputView(question: question, answer: answer, frame: frame)
        
        let binder = StackViewToRadioBtnsWithInputViewModelBinder.init()
        binder.hookUp(btnViews: result.1 as! [RadioBtnView],
                      viewmodel: viewmodel as! RadioWithInputViewModel,
                      bag: self.helperFactories.bag)
        
        self.resultView = result.0
        
    }
    
}






class ViewStackerForCheckboxWithInputQuestion: QuestionViewProviding {
    
    private var helperFactories: HelperFactories
    var resultView: UIView
    
    init(helperFactories: HelperFactories, question: PresentQuestion, answer: Answering?, frame: CGRect, viewmodel: Questanable) {
        
        self.helperFactories = helperFactories
        
        let factory = CheckboxBtnsWithInputViewFactory.init(
            sameComponentsFactory: helperFactories.sameComponentsFactory,
            questionViewWithHeadlineLabelFactory: helperFactories.questionViewWithHeadlineLabelFactory,
            bag: helperFactories.bag,
            delegate: helperFactories.delegate)
        
        let result: (UIView, [UIView]) = factory.getCheckboxBtnsWithInputView(question: question, answer: answer, frame: frame)
        let binder = StackViewToCheckboxBtnsWithInputViewModelBinder.init()
        
        binder.hookUp(btnViews: result.1,
                      viewmodel: viewmodel as! CheckboxWithInputViewModel,
                      bag: helperFactories.bag)
        
        self.resultView = result.0
        
    }
}

class ViewStackerForSwitchQuestion: QuestionViewProviding {
    
    private var helperFactories: HelperFactories
    var resultView: UIView
    
    init(helperFactories: HelperFactories, question: PresentQuestion, answer: Answering?, frame: CGRect, viewmodel: Questanable) {
        
        self.helperFactories = helperFactories
        
        let factory = SwitchBtnsViewFactory.init(
            sameComponentsFactory: helperFactories.sameComponentsFactory,
            questionViewWithHeadlineLabelFactory: helperFactories.questionViewWithHeadlineLabelFactory,
            bag: helperFactories.bag,
            delegate: helperFactories.delegate)
        
        let result: (UIView, [UIView]) = factory.getSwitchBtnsView(question: question, answer: answer, frame: frame)
        let binder = StackViewToSwitchBtnsViewModelBinder.init()
        
        binder.hookUp(btnViews: result.1 as! [LabelBtnSwitchView],
                      viewmodel: viewmodel as! SwitchBtnsViewModel,
                      bag: helperFactories.bag)
        
        self.resultView = result.0
        
    }
}













class HelperFactories {
    var sameComponentsFactory: SameComponentsFactory
    var questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory
    var bag: DisposeBag
    var delegate: UITextViewDelegate?
    
    init(questionsAnswersCalculator: QuestionsAnswersTableWidthCalculating,
         bag: DisposeBag,
         delegate: UITextViewDelegate?) {
        
        self.sameComponentsFactory = SameComponentsFactory(questionsWidthProvider: questionsAnswersCalculator)
        self.questionViewWithHeadlineLabelFactory = QuestionViewWithHeadlineLabelFactory()
        self.delegate = delegate
        self.bag = bag
    }
    
    init(sameComponentsFactory: SameComponentsFactory,
         questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory,
         bag: DisposeBag,
         delegate: UITextViewDelegate?) {
        
        self.sameComponentsFactory = sameComponentsFactory
        self.questionViewWithHeadlineLabelFactory = questionViewWithHeadlineLabelFactory
        self.bag = bag
        self.delegate = delegate
    }
}
