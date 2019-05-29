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
    
    private var viewFactory: ViewFactory
    private var bag: DisposeBag
    private var delegate: UITextViewDelegate?
    
    private let radioBtnsViewModelBinder = StackViewToRadioBtnsViewModelBinder()
    private let radioBtnsWithInputViewModelBinder = StackViewToRadioBtnsWithInputViewModelBinder()
    private let checkboxBtnsViewModelBinder = StackViewToCheckboxBtnsViewModelBinder()
    private let checkboxBtnsWithInputViewModelBinder = StackViewToCheckboxBtnsWithInputViewModelBinder()
    private let switchBtnsViewModelBinder = StackViewToSwitchBtnsViewModelBinder()
    private let txtFieldToViewModelBinder = TextFieldToViewModelBinder()
    private let txtViewToDropdownViewModelBinder = TextViewToDropdownViewModelBinder()
    private let termsSwitchBtnsViewModelBinder = StackViewToTermsViewModelBinder()
    
    init(viewFactory: ViewFactory, bag: DisposeBag, delegate: UITextViewDelegate?) {
        self.viewFactory = viewFactory
        self.bag = bag
        self.delegate = delegate
    }
    
    func drawStackView(questionsOfSameType questions: [SingleQuestion], viewmodel: Questanable) -> UIView {
        
        guard questions.count > 0 else {fatalError()}

        let singleQuestion = questions.first!
        
        let height = tableRowHeightCalculator.getOneRowHeightRegardingDevice(componentType: singleQuestion.question.type)
        let fr = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: viewFactory.bounds.width, height: height))
        
        var finalView: UIView!
        var btnViews: [UIView]
        
        switch singleQuestion.question.type {
        
        case .textField:
            let res = self.getLabelAndTextField(question: singleQuestion.question,
                                                answer: singleQuestion.answer,
                                                frame: fr)
            let stackerView = res.0; btnViews = res.1
            
            _ = btnViews.map { (btnView) -> () in
                txtFieldToViewModelBinder.hookUp(view: stackerView,
                                                 labelAndTextView: btnView as! LabelAndTextField,
                                                 viewmodel: viewmodel as! LabelWithTextFieldViewModel,
                                                 bag: bag)
            }

            finalView = stackerView
            
        case .textArea:
            
            let res = self.getLabelAndTextView(question: singleQuestion.question,
                                               answer: singleQuestion.answer,
                                               frame: fr)
            let stackerView = res.0; btnViews = res.1
            
            txtViewToDropdownViewModelBinder.hookUp(view: stackerView,
                                                    labelAndTextView: btnViews.first as! LabelAndTextView,
                                                    viewmodel: viewmodel as! SelectOptionTextFieldViewModel,
                                                    bag: bag)
            
            let resized = CGRect.init(origin: stackerView.frame.origin,
                                      size: CGSize.init(width: stackerView.bounds.width,
                                                        height: CGFloat.init(integerLiteral: 200)))
            stackerView.frame = resized
            
            finalView = stackerView
            
        case .dropdown:
            let res = self.getLabelAndTextView(question: singleQuestion.question,
                                               answer: singleQuestion.answer,
                                               frame: fr)
            let stackerView = res.0; btnViews = res.1
            
            txtViewToDropdownViewModelBinder.hookUp(view: stackerView,
                                                    labelAndTextView: btnViews.first as! LabelAndTextView,
                                                    viewmodel: viewmodel as! SelectOptionTextFieldViewModel,
                                                    bag: bag)
            
            stackerView.resizeHeight(by: 20)
            
            (btnViews.first as! LabelAndTextView).textView.delegate = delegate
            
            finalView = stackerView
            
        case .radioBtn:
            
            let res = self.getRadioBtnsQuestionView(question: singleQuestion.question,
                                                    answer: singleQuestion.answer,
                                                    frame: fr)
            
            finalView = res.0; btnViews = res.1
            
            radioBtnsViewModelBinder.hookUp(view: finalView.subviews.last as! ViewStacker,
                                            btnViews: btnViews as! [RadioBtnView],
                                            viewmodel: viewmodel as! RadioViewModel,
                                            bag: bag)
            
        case .checkbox:
            let res = self.getCheckboxBtnsQuestionView(question: singleQuestion.question,
                                                       answer: singleQuestion.answer,
                                                       frame: fr)
            finalView = res.0; btnViews = res.1
            
            checkboxBtnsViewModelBinder.hookUp(view: finalView.subviews.last as! ViewStacker,
                                               btnViews: btnViews as! [CheckboxView],
                                               viewmodel: viewmodel as! CheckboxViewModel,
                                               bag: bag)
            
        case .radioBtnWithInput:
            let res = self.getRadioBtnsWithInputQuestionView(question: singleQuestion.question,
                                                                   answer: singleQuestion.answer,
                                                                   frame: fr)
            finalView = res.0; btnViews = res.1
            
            radioBtnsWithInputViewModelBinder.hookUp(view: finalView.subviews.last as! ViewStacker,
                                                     btnViews: btnViews as! [RadioBtnView],
                                                     viewmodel: viewmodel as! RadioWithInputViewModel,
                                                     bag: bag)
            
        case .checkboxWithInput:
            let res = self.getCheckboxBtnsWithInputView(question: singleQuestion.question,
                                                       answer: singleQuestion.answer,
                                                       frame: fr)
            finalView = res.0; btnViews = res.1
            
            checkboxBtnsWithInputViewModelBinder.hookUp(view: finalView.subviews.last as! ViewStacker,
                                                        btnViews: btnViews as! [CheckboxView],
                                                        viewmodel: viewmodel as! CheckboxWithInputViewModel,
                                                        bag: bag)
            
        case .switchBtn:
            let res = self.getSwitchBtnsQuestion(question: singleQuestion.question,
                                                 answer: singleQuestion.answer,
                                                 frame: fr)
            finalView = res.0; btnViews = res.1
            
            switchBtnsViewModelBinder.hookUp(view: finalView.subviews.last as! ViewStacker,
                                             btnViews: btnViews as! [LabelBtnSwitchView],
                                             viewmodel: viewmodel as! SwitchBtnsViewModel,
                                             bag: bag)
            
        case .termsSwitchBtn:
            let res = self.getTermsSwitchBtnsQuestion(question: singleQuestion.question,
                                                      answer: singleQuestion.answer,
                                                      frame: fr)
            finalView = res.0; btnViews = res.1
            
            termsSwitchBtnsViewModelBinder.hookUp(view: finalView.subviews.last as! ViewStacker,
                                                  btnViews: btnViews as! [TermsLabelBtnSwitchView],
                                                  viewmodel: viewmodel as! SwitchBtnsViewModel,
                                                  bag: bag)
            
        default: break
        }
        
        return finalView
        
    }
    
    private func getRadioBtnsQuestionView(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (UIView, [RadioBtnView]) {
        
        let stackerView = viewFactory.getStackedRadioBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [RadioBtnView] in
            return (view as? OneRowStacker)?.components as? [RadioBtnView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.radioBtn.tag = $0.offset } // dodeli svakome unique TAG
        
        let finalView = self.questionViewWithHeadlineLabel(question: question, aboveStackerView: stackerView)
        
        return (finalView, btnViews)
        
    }
    
    private func getCheckboxBtnsQuestionView(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (UIView, [CheckboxView]) {
    
        let stackerView = viewFactory.getStackedCheckboxBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [CheckboxView] in
            return (view as? OneRowStacker)?.components as? [CheckboxView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.radioBtn.tag = $0.offset } // dodeli svakome unique TAG
        
        let finalView = self.questionViewWithHeadlineLabel(question: question, aboveStackerView: stackerView)
        
        return (finalView, btnViews)
        
    }
    
    private func getRadioBtnsWithInputQuestionView(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (UIView, [UIView]) {
        
        let stackerView = viewFactory.getStackedRadioBtnsWithInput(question: question, answer: answer, frame: frame)
        
        let elements = stackerView.components.flatMap { view -> [UIView] in
            return (view as? OneRowStacker)?.components ?? [ ]
        }
        
        _ = elements.enumerated().map {
            if $0.offset == elements.count - 1 {
                $0.element.tag = $0.offset
            } else if let btnView = $0.element as? RadioBtnView  {
                btnView.radioBtn.tag = $0.offset
            }
        } // dodeli svakome unique TAG
        
        let finalView = questionViewWithHeadlineLabel(question: question, aboveStackerView: stackerView)
        
        return (finalView, elements)
        
    }
    
    private func getCheckboxBtnsWithInputView(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (UIView, [UIView]) {
        
        let stackerView = viewFactory.getStackedCheckboxBtnsWithInput(question: question, answer: answer, frame: frame)
        
        let elements = stackerView.components.flatMap { view -> [UIView] in
            return (view as? OneRowStacker)?.components ?? [ ]
        }
        
        _ = elements.enumerated().map {
            if $0.offset == elements.count - 1 {
                $0.element.tag = $0.offset
            } else if let btnView = $0.element as? CheckboxView  {
                btnView.radioBtn.tag = $0.offset
            }
        } // dodeli svakome unique TAG
        
        let finalView = questionViewWithHeadlineLabel(question: question, aboveStackerView: stackerView)
        
        return (finalView, elements)
    }
    
    private func getSwitchBtnsQuestion(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (UIView, [UIView]) {
        
        let stackerView = viewFactory.getStackedSwitchBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [LabelBtnSwitchView] in
            return (view as? OneRowStacker)?.components as? [LabelBtnSwitchView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.switcher.tag = $0.offset } // dodeli svakome unique TAG
        
        //let finalView = questionViewWithHeadlineLabelForSwitchView(question: question, aboveStackerView: stackerView)
        
        let finalView = questionViewWithHeadlineLabel(question: question, aboveStackerView: stackerView)
        
        return (finalView, btnViews)
    }
    
    private func getTermsSwitchBtnsQuestion(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (UIView, [UIView]) {
        
        let stackerView = viewFactory.getStackedTermsSwitchBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [TermsLabelBtnSwitchView] in
            return (view as? OneRowStacker)?.components as? [TermsLabelBtnSwitchView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.switcher.tag = $0.offset } // dodeli svakome unique TAG
        
        let finalView = questionViewWithHeadlineLabel(question: question, aboveStackerView: stackerView)
        
        return (finalView, btnViews)
    }
    
    private func getLabelAndTextField(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (ViewStacker, [LabelAndTextField]) {
        
        //let stackerView = viewFactory.getStackedLblAndTextField(questionWithAnswers: question, frame: frame)
        let stackerView = viewFactory.getStackedLblAndTextField(questionWithAnswers: [(question, answer)], frame: frame)
        
        let views = stackerView.components.flatMap { view -> [LabelAndTextField] in
            return (view as? OneRowStacker)?.components as? [LabelAndTextField] ?? [ ]
        }
        
        _ = views.enumerated().map { $0.element.textField.tag = $0.offset } // dodeli svakome unique TAG
        
        return (stackerView, views)
        
    }
    
    // refactor ovo, mora biti samo 1 !!!
    private func getLabelAndTextView(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (ViewStacker, [LabelAndTextView]) {
        
        //let stackerView = viewFactory.getStackedLblAndTextView(question: question, answer: answer, frame: frame)
        let stackerView = viewFactory.getStackedLblAndTextView(questionWithAnswers: [(question, answer)], frame: frame)
        
        let views = stackerView.components.flatMap { view -> [LabelAndTextView] in
            return (view as? OneRowStacker)?.components as? [LabelAndTextView] ?? [ ]
        }
        
        _ = views.enumerated().map { $0.element.textView.tag = question.id } // dodeli mu unique TAG kakav je questionId !!
        
        return (stackerView, views)
        
    }
    
//    private func questionViewWithHeadlineLabel(question: PresentQuestion, aboveStackerView stackerView: ViewStacker) -> UIView {
//        let titleLabel = UILabel.init(frame: CGRect.init(origin: stackerView.frame.origin,
//                                                         size: CGSize.init(width: stackerView.bounds.width,
//                                                                           height: tableRowHeightCalculator.getHeadlineHeightForDeviceType())))
//        titleLabel.backgroundColor = .red
//        titleLabel.numberOfLines = 0
//        titleLabel.text = question.headlineText
//
//        let finalView = UIView()
//        finalView.addSubview(titleLabel)
//        finalView.frame = CGRect.init(origin: stackerView.frame.origin, size: CGSize.init(width: stackerView.bounds.width, height: stackerView.bounds.height + titleLabel.bounds.height))
//        let stackerShifted = stackerView
//        stackerShifted.frame.origin.y += titleLabel.bounds.height
//        finalView.insertSubview(stackerShifted, at: 1)
//
//        return finalView
//    }
    private func questionViewWithHeadlineLabel(question: PresentQuestion, aboveStackerView stackerView: ViewStacker) -> UIView {
        
        return headlinedQuestionView(question: question, aboveStackerView: stackerView) // refactor u podfunc
        
    }
    
    private func headlinedQuestionView(question: PresentQuestion, aboveStackerView stackerView: ViewStacker) -> UIView {
        
        let titleLabel = getHeadlineLabel(question: question, aboveStackerView: stackerView)
        
        let finalView = UIView()
        finalView.addSubview(titleLabel)
        finalView.frame = CGRect.init(origin: stackerView.frame.origin, size: CGSize.init(width: stackerView.bounds.width, height: stackerView.bounds.height + titleLabel.bounds.height))
        let stackerShifted = stackerView
        stackerShifted.frame.origin.y += titleLabel.bounds.height
        finalView.insertSubview(stackerShifted, at: 1)
        
        return finalView
    }
    
    private func getHeadlineLabel(question: PresentQuestion, aboveStackerView stackerView: ViewStacker) -> UILabel {
        let titleLabel = UILabel.init(frame: CGRect.init(origin: stackerView.frame.origin,
                                                         size: CGSize.init(width: stackerView.bounds.width,
                                                                           height: tableRowHeightCalculator.getHeadlineHeightForDeviceType())))
        titleLabel.backgroundColor = .red
        titleLabel.numberOfLines = 0
        titleLabel.text = question.headlineText
        
        if question.headlineText == "" {
            titleLabel.frame = CGRect.init(origin: titleLabel.frame.origin,
                                           size: CGSize.init(width: titleLabel.bounds.width,
                                                             height: CGFloat(0)))
        }
        
        return titleLabel
    }
    
}
