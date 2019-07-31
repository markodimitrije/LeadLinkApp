//
//  ViewStackerForTextFieldQuestion.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 31/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class ViewStackerForTextFieldQuestion: QuestionViewProviding {
    
    private var helperFactories: HelperFactories
    var resultView: UIView
    
    init(helperFactories: HelperFactories, question: PresentQuestion, answer: Answering?, frame: CGRect, viewmodel: Questanable) {
        
        self.helperFactories = helperFactories
        
        let factory = LabelWithTxtFieldFactory.init(
            sameComponentsFactory: helperFactories.sameComponentsFactory,
            questionViewWithHeadlineLabelFactory: helperFactories.questionViewWithHeadlineLabelFactory,
            bag: helperFactories.bag,
            delegate: helperFactories.delegate)
        
        let result: (ViewStacker, [LabelAndTextField]) = factory.getLabelAndTextField(question: question, answer: answer, frame: frame)
        let binder = TextFieldToViewModelBinder.init()
        
        let selector = (question.options.first == "phone") ? #selector(doneButtonAction(_:)) : nil;
        
        binder.hookUp(labelAndTextView: result.1.first!,
                      viewmodel: viewmodel as! LabelWithTextFieldViewModel,
                      bag: helperFactories.bag,
                      selector: selector)
        
        self.resultView = result.0
        
    }
    
    @objc func doneButtonAction(_ labelAndTextView: LabelAndTextField) {
        labelAndTextView.textField.endEditing(true)
    }
    
}
