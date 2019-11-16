//
//  ViewStackerForDropdownQuestion.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 31/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class ViewStackerForDropdownQuestion: QuestionViewProviding {
    
    private var helperFactories: HelperFactories
    var resultView: UIView
    
    init(helperFactories: HelperFactories, question: PresentQuestion, answer: Answering?, frame: CGRect, viewmodel: Questanable) {
        
        self.helperFactories = helperFactories
        
        let factory = LabelWithTextViewFactory.init(
            sameComponentsFactory: helperFactories.sameComponentsFactory,
            questionViewWithHeadlineLabelFactory: helperFactories.questionViewWithHeadlineLabelFactory,
            bag: helperFactories.bag,
            delegate: helperFactories.delegate)
        
        let result: (ViewStacker, [LabelAndTextView]) = factory.getLabelAndTextView(question: question, answer: answer, frame: frame)
        let binder = TextViewToDropdownViewModelBinder.init()
        
        binder.hookUp(labelAndTextView: result.1.first!,
                      viewmodel: viewmodel as! SelectOptionTextFieldViewModel,
                      bag: helperFactories.bag)
        
        let stackerView = result.0
        
        if (answer?.content.count ?? 0) < 10 {
            stackerView.resizeHeight(by: 50)
        }
        
        if let answer = answer {
            (result.1.first?.textView as? OptionsTextView)?.formatLayout(accordingToOptions: answer.content)
        }
        
        result.1.first?.textView.delegate = helperFactories.delegate
        
        self.resultView = stackerView
        
    }
    
}
