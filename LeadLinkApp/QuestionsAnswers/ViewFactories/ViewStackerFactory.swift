//
//  ViewStackerFactory.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 11/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewStackerFactory {
    
    private var questionsWidthProvider: QuestionsAnswersTableWidthCalculating
    private var bag: DisposeBag
    private var delegate: UITextViewDelegate?
    
    private let radioBtnsViewModelBinder = StackViewToRadioBtnsViewModelBinder()
    private let radioBtnsWithInputViewModelBinder = StackViewToRadioBtnsWithInputViewModelBinder()
    private let checkboxBtnsViewModelBinder = StackViewToCheckboxBtnsViewModelBinder()
    private let checkboxBtnsWithInputViewModelBinder = StackViewToCheckboxBtnsWithInputViewModelBinder()
    //private let switchBtnsViewModelBinder = StackViewToSwitchBtnsViewModelBinder()
    private let txtFieldToViewModelBinder = TextFieldToViewModelBinder()
    private let txtViewToDropdownViewModelBinder = TextViewToDropdownViewModelBinder()
    private let termsSwitchBtnsViewModelBinder = StackViewToTermsViewModelBinder()
    private let textAreaViewModelBinder = TextAreaViewModelBinder()
    
    lazy var radioBtnsViewFactory = RadioBtnsViewFactory(
        sameComponentsFactory: SameComponentsFactory(questionsWidthProvider: questionsWidthProvider),
        questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory(),
        bag: bag,
        delegate: delegate!)
    
    lazy var radioBtnsWithInputViewFactory = RadioBtnsWithInputViewFactory(
        sameComponentsFactory: SameComponentsFactory(questionsWidthProvider: questionsWidthProvider),
        questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory(),
        bag: bag,
        delegate: delegate!)
    
    lazy var checkboxBtnsViewFactory = CheckboxBtnsViewFactory(
        sameComponentsFactory: SameComponentsFactory(questionsWidthProvider: questionsWidthProvider),
        questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory(),
        bag: bag,
        delegate: delegate!)
    
    lazy var checkboxBtnsWithInputViewFactory = CheckboxBtnsWithInputViewFactory(
        sameComponentsFactory: SameComponentsFactory(questionsWidthProvider: questionsWidthProvider),
        questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory(),
        bag: bag,
        delegate: delegate!)
    
    lazy var switchBtnsViewFactory = SwitchBtnsViewFactory(
        sameComponentsFactory: SameComponentsFactory(questionsWidthProvider: questionsWidthProvider),
        questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory(),
        bag: bag,
        delegate: delegate!)
    
    lazy var termsSwitchBtnsViewFactory = TermsSwitchBtnsViewFactory(
        sameComponentsFactory: SameComponentsFactory(questionsWidthProvider: questionsWidthProvider),
        questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory(),
        bag: bag,
        delegate: delegate!)
    
    lazy var labelWithTxtFieldFactory = LabelWithTxtFieldFactory(
        sameComponentsFactory: SameComponentsFactory(questionsWidthProvider: questionsWidthProvider),
        questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory(),
        bag: bag,
        delegate: delegate!)
    
    lazy var labelWithTxtViewFactory = LabelWithTxtViewFactory(
        sameComponentsFactory: SameComponentsFactory(questionsWidthProvider: questionsWidthProvider),
        questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory(),
        bag: bag,
        delegate: delegate!)
    
    
    init(questionsWidthProvider: QuestionsAnswersTableWidthCalculating, bag: DisposeBag, delegate: UITextViewDelegate?) {
        self.questionsWidthProvider = questionsWidthProvider
        self.bag = bag
        self.delegate = delegate
    }
    
    func drawStackView(questionsOfSameType questions: [SurveyQuestion], viewmodel: Questanable) -> UIView {
        
        let questionViewFactory: MyQuestionViewFactory = MyQuestionViewFactory(
            sameComponentsFactory: SameComponentsFactory(questionsWidthProvider: questionsWidthProvider),
            questionViewHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory(),
            bag: bag,
            delegate: delegate)
        
        guard questions.count > 0 else {fatalError()}

        let surveyQuestion = questions.first!
        
        let height = tableRowHeightCalculator.getOneRowHeight(componentType: surveyQuestion.question.type)
        let fr = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: questionsWidthProvider.getWidth(),
                                                                     height: height))
        switch surveyQuestion.question.type {
            
        case .radioBtn:
            
            return questionViewFactory.makeViewStacker(question: surveyQuestion, answer: surveyQuestion.answer, frame: fr, viewmodel: viewmodel)!
            
        case .checkbox:
            
            return questionViewFactory.makeViewStacker(question: surveyQuestion, answer: surveyQuestion.answer, frame: fr, viewmodel: viewmodel)!
            
        case .radioBtnWithInput:
            
//            return makeFinalViewForRadioWithInput(surveyQuestion: surveyQuestion, viewmodel: viewmodel, frame: fr)
            return questionViewFactory.makeViewStacker(question: surveyQuestion, answer: surveyQuestion.answer, frame: fr, viewmodel: viewmodel)!
            
        case .checkboxWithInput:
            
//            return makeFinalViewForCheckboxWithInput(surveyQuestion: surveyQuestion, viewmodel: viewmodel, frame: fr)
            return questionViewFactory.makeViewStacker(question: surveyQuestion, answer: surveyQuestion.answer, frame: fr, viewmodel: viewmodel)!
        
        case .switchBtn: // OK
            
            return questionViewFactory.makeViewStacker(question: surveyQuestion, answer: surveyQuestion.answer, frame: fr, viewmodel: viewmodel)!
            
            
            
            
            
            
            
            
            
        case .textField:

            return makeFinalViewForTextField(surveyQuestion: surveyQuestion, viewmodel: viewmodel, frame: fr)
            
        case .textArea:

            return makeFinalViewForTextArea(surveyQuestion: surveyQuestion, viewmodel: viewmodel, frame: fr)
            
        case .dropdown:

            return makeFinalViewForDropdown(surveyQuestion: surveyQuestion, viewmodel: viewmodel, frame: fr)
            
        case .termsSwitchBtn:

            return makeFinalViewForTermsSwitch(surveyQuestion: surveyQuestion, viewmodel: viewmodel, frame: fr)
            
        }
        
    }
    
    private func makeFinalViewForTextField(surveyQuestion: SurveyQuestion,
                                           viewmodel: Questanable,
                                           frame: CGRect) -> UIView {
        
        let res = labelWithTxtFieldFactory.getLabelAndTextField(question: surveyQuestion.question,
                                                                answer: surveyQuestion.answer,
                                                                frame: frame)
        let stackerView = res.0; let btnViews = res.1
        
        let selector = (surveyQuestion.question.options.first == "phone") ? #selector(doneButtonAction(_:)) : nil;
        
        _ = btnViews.map { (btnView) -> () in
            txtFieldToViewModelBinder.hookUp(labelAndTextView: btnView,
                                             viewmodel: viewmodel as! LabelWithTextFieldViewModel,
                                             bag: bag,
                                             selector: selector)
        }
        
        return stackerView
    }
    
    private func makeFinalViewForTextArea(surveyQuestion: SurveyQuestion,
                                          viewmodel: Questanable,
                                          frame: CGRect) -> UIView {
        
        let res = labelWithTxtViewFactory.getLabelAndTextView(question: surveyQuestion.question,
                                                              answer: surveyQuestion.answer,
                                                              frame: frame)

        let stackerView = res.0; let btnViews = res.1

        textAreaViewModelBinder.hookUp(labelAndTextView: btnViews.first!,
                                       viewmodel: viewmodel as! LabelWithTextFieldViewModel,
                                       bag: bag)

        let resized = CGRect.init(origin: stackerView.frame.origin,
                                  size: CGSize.init(width: stackerView.bounds.width,
                                                    height: frame.height))
        stackerView.frame = resized

        return stackerView
    }
    
    private func makeFinalViewForDropdown(surveyQuestion: SurveyQuestion,
                                          viewmodel: Questanable,
                                          frame: CGRect) -> UIView {
        
        let res = labelWithTxtViewFactory.getLabelAndTextView(question: surveyQuestion.question,
                                                              answer: surveyQuestion.answer,
                                                              frame: frame)
        let stackerView = res.0; let btnViews = res.1
        
        txtViewToDropdownViewModelBinder.hookUp(labelAndTextView: btnViews.first!,
                                                viewmodel: viewmodel as! SelectOptionTextFieldViewModel,
                                                bag: bag)
        
        stackerView.resizeHeight(by: 20)
        
        btnViews.first?.textView.delegate = delegate
        
        return stackerView
    }
    
    private func makeFinalViewForRadioWithInput(surveyQuestion: SurveyQuestion,
                                           viewmodel: Questanable,
                                           frame: CGRect) -> UIView  {
        
        let res = radioBtnsWithInputViewFactory.getRadioBtnsWithInputView(question: surveyQuestion.question,
                                                                          answer: surveyQuestion.answer,
                                                                          frame: frame)
        let finalView = res.0; let btnViews = res.1
        
        radioBtnsWithInputViewModelBinder.hookUp(btnViews: btnViews as! [RadioBtnView],
                                                 viewmodel: viewmodel as! RadioWithInputViewModel,
                                                 bag: bag)
        
        return finalView
    }
    
    private func makeFinalViewForCheckboxWithInput(surveyQuestion: SurveyQuestion,
                                           viewmodel: Questanable,
                                           frame: CGRect) -> UIView  {
        
        let res = checkboxBtnsWithInputViewFactory.getCheckboxBtnsWithInputView(
            question: surveyQuestion.question,
            answer: surveyQuestion.answer,
            frame: frame)
        
        let finalView = res.0; let btnViews = res.1
        
        checkboxBtnsWithInputViewModelBinder.hookUp(btnViews: btnViews as! [CheckboxView],
                                                    viewmodel: viewmodel as! CheckboxWithInputViewModel,
                                                    bag: bag)
        
        return finalView
    }
    
    private func makeFinalViewForTermsSwitch(surveyQuestion: SurveyQuestion,
                                     viewmodel: Questanable,
                                     frame: CGRect) -> UIView  {
        
        let res = termsSwitchBtnsViewFactory.getTermsSwitchBtnsView(question: surveyQuestion.question,
                                                                    answer: surveyQuestion.answer,
                                                                    frame: frame)
        let finalView = res.0; let btnViews = res.1
        
        termsSwitchBtnsViewModelBinder.hookUp(btnViews: btnViews as! [TermsLabelBtnSwitchView],
                                              viewmodel: viewmodel as! SwitchBtnsViewModel,
                                              bag: bag)
        return finalView
        
    }
    
    
    @objc func doneButtonAction(_ labelAndTextView: LabelAndTextField) {
        labelAndTextView.textField.endEditing(true)
    }
    
}
