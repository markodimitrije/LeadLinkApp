//
//  ViewStackerForPhoneTextFieldQuestion.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 06/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class ViewStackerForPhoneTextFieldQuestion: NSObject, QuestionViewProviding {
    
    private var helperFactories: HelperFactories
    var resultView: UIView
    private var phoneTextFields = [UITextField]()
    
    init(helperFactories: HelperFactories, question: PresentQuestion, answer: Answering?, frame: CGRect, viewmodel: Questanable) {
        
        self.helperFactories = helperFactories
        
        let factory = LabelWithPhoneTextFieldFactory.init(
            sameComponentsFactory: helperFactories.sameComponentsFactory,
            questionViewWithHeadlineLabelFactory: helperFactories.questionViewWithHeadlineLabelFactory,
            bag: helperFactories.bag,
            delegate: helperFactories.delegate)
        
        let result: (ViewStacker, [LabelAndPhoneTextField]) = factory.getLabelAndTextField(question: question, answer: answer, frame: frame)
        let binder = PhoneTextFieldViewModelBinder.init()
        
        binder.hookUp(labelAndTextView: result.1.first!,
                      viewmodel: viewmodel as! LabelWithPhoneTextFieldViewModel,
                      bag: helperFactories.bag)
        
        self.resultView = result.0
        
        super.init()
        
    }

}
