//
//  ViewStackerForRadioQuestion.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 31/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class ViewStackerForRadioQuestion: QuestionViewProviding {
    
    private var helperFactories: HelperFactories
    var resultView: UIView
    
    init(helperFactories: HelperFactories, surveyQuestion: SurveyQuestion, viewmodel: Questanable) {
        
        self.helperFactories = helperFactories
        
        let radioFactory = RadioBtnsViewFactory.init(
            sameComponentsFactory: helperFactories.sameComponentsFactory,
            questionViewWithHeadlineLabelFactory: helperFactories.questionViewWithHeadlineLabelFactory,
            bag: helperFactories.bag,
            delegate: helperFactories.delegate)
        
        let result: (UIView, [RadioBtnView]) = radioFactory.getRadioBtnsView(surveyQuestion: surveyQuestion)
        
        let binder = StackViewToRadioBtnsViewModelBinder.init()
        binder.hookUp(btnViews: result.1,
                      viewmodel: viewmodel as! RadioViewModel,
                      bag: helperFactories.bag)
        
        self.resultView = result.0
        
    }
}
