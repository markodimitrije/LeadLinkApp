//
//  RadioBtnsViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class RadioBtnsViewFactory {
    
    var sameComponentsFactory: SameComponentsFactory
    var questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory
    var bag: DisposeBag
    var delegate: UITextViewDelegate
    
    init(sameComponentsFactory: SameComponentsFactory,
         questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory,
         bag: DisposeBag,
         delegate: UITextViewDelegate) {
        
        self.sameComponentsFactory = sameComponentsFactory
        self.questionViewWithHeadlineLabelFactory = questionViewWithHeadlineLabelFactory
        self.bag = bag
        self.delegate = delegate
    }
    
    func getRadioBtnsView(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (UIView, [RadioBtnView]) {
        
        let stackerView = self.getStackedRadioBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [RadioBtnView] in
            return (view as? OneRowStacker)?.components as? [RadioBtnView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.radioBtn.tag = $0.offset } // dodeli svakome unique TAG
        
        let finalView = questionViewWithHeadlineLabelFactory.questionViewWithHeadlineLabel(question: question, aboveStackerView: stackerView)
        
        return (finalView, btnViews)
        
    }
    
    func getStackedRadioBtns(question: PresentQuestion, answer: Answering?, frame: CGRect) -> ViewStacker {
        
        //return produceStackWithSameComponents(ofType: RadioBtnView.self, count: question.options.count, elementsInOneRow: 3)!
        return sameComponentsFactory.createStackWithSameComponents(ofType: RadioBtnView.self, componentsTotalCount: question.options.count, elementsInOneRow: 1)!
        
    }
}
