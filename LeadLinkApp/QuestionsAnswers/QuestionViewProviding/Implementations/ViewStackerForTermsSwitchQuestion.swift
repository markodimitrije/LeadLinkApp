//
//  ViewStackerForTermsSwitchQuestion.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 31/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class ViewStackerForTermsSwitchQuestion: QuestionViewProviding {
    
    private var helperFactories: HelperFactories
    var resultView: UIView
    
    init(helperFactories: HelperFactories, question: PresentQuestion, answer: Answering?, frame: CGRect, viewmodel: Questanable) {
        
        self.helperFactories = helperFactories
        
        let factory = TermsSwitchBtnsViewFactory.init(
            sameComponentsFactory: helperFactories.sameComponentsFactory,
            questionViewWithHeadlineLabelFactory: helperFactories.questionViewWithHeadlineLabelFactory,
            bag: helperFactories.bag,
            delegate: helperFactories.delegate)
        
        let result: (UIView, [UIView]) = factory.getTermsSwitchBtnsView(question: question, answer: answer, frame: frame)
        let binder = StackViewToTermsViewModelBinder.init()
        
        binder.hookUp(btnViews: result.1 as! [TermsLabelBtnSwitchView],
                      viewmodel: viewmodel as! SwitchBtnsViewModel,
                      bag: helperFactories.bag)
        
        self.resultView = result.0
        
    }
    
}
