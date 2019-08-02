//
//  ViewStackerForRadioWithInputQuestion.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 31/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class ViewStackerForRadioWithInputQuestion: QuestionViewProviding {
    
    private var helperFactories: HelperFactories
    var resultView: UIView
    
    init(helperFactories: HelperFactories, surveyQuestion: SurveyQuestion, viewmodel: Questanable) {
        
        self.helperFactories = helperFactories
        
        let factory = RadioBtnsWithInputViewFactory.init(
            sameComponentsFactory: helperFactories.sameComponentsFactory,
            questionViewWithHeadlineLabelFactory: helperFactories.questionViewWithHeadlineLabelFactory,
            bag: helperFactories.bag,
            delegate: helperFactories.delegate)
        
        let result: (UIView, [UIView]) = factory.getRadioBtnsWithInputView(surveyQuestion: surveyQuestion)
        
        let binder = StackViewToRadioBtnsWithInputViewModelBinder.init()
        binder.hookUp(btnViews: result.1 as! [RadioBtnView],
                      viewmodel: viewmodel as! RadioWithInputViewModel,
                      bag: self.helperFactories.bag)
        
        self.resultView = result.0
        
    }
    
}

