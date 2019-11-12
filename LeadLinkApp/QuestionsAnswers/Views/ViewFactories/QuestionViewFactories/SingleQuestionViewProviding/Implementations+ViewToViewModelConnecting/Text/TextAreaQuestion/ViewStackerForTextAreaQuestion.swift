//
//  ViewStackerForTextAreaQuestion.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 31/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class ViewStackerForTextAreaQuestion: QuestionViewProviding {
    
    private var helperFactories: HelperFactories
    var resultView: UIView
    
    init(helperFactories: HelperFactories, question: PresentQuestion, answer: Answering?, frame: CGRect, viewmodel: Questanable) {
        
        self.helperFactories = helperFactories
        
        let factory = LabelWithTxtViewFactory.init(
            sameComponentsFactory: helperFactories.sameComponentsFactory,
            questionViewWithHeadlineLabelFactory: helperFactories.questionViewWithHeadlineLabelFactory,
            bag: helperFactories.bag,
            delegate: helperFactories.delegate)
        
        let result: (ViewStacker, [LabelAndTextView]) = factory.getLabelAndTextView(question: question, answer: answer, frame: frame)
        let binder = TextAreaViewModelBinder.init()
        
        binder.hookUp(labelAndTextView: result.1.first!,
                      viewmodel: viewmodel as! LabelWithTextFieldViewModel,
                      bag: helperFactories.bag)
        
        let stackerView = result.0
        
        self.resultView = stackerView
        
    }
    
}
