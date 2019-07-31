//
//  ViewStackerForCheckboxWithInputQuestion.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 31/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

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

