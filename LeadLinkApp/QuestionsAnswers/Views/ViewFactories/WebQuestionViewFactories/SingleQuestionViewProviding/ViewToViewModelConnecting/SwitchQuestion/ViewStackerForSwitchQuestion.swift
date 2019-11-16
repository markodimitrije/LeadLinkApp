//
//  ViewStackerForSwitchQuestion.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 31/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

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