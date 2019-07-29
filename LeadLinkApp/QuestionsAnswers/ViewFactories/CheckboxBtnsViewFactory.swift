//
//  CheckboxBtnsViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class CheckboxBtnsViewFactory {
    
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
    
    func getCheckboxBtnsView(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (UIView, [CheckboxView]) {
        
        let stackerView = self.getStackedCheckboxBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [CheckboxView] in
            return (view as? OneRowStacker)?.components as? [CheckboxView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.radioBtn.tag = $0.offset } // dodeli svakome unique TAG
        
        let finalView = questionViewWithHeadlineLabelFactory.questionViewWithHeadlineLabel(question: question, aboveStackerView: stackerView)
        
        return (finalView, btnViews)
        
    }
    
    private func getStackedCheckboxBtns(question: PresentQuestion, answer: Answering?, frame: CGRect) -> ViewStacker {
        
        //return produceStackWithSameComponents(ofType: CheckboxView.self, count: question.options.count, elementsInOneRow: 3)!
        return sameComponentsFactory.createStackWithSameComponents(ofType: CheckboxView.self, componentsTotalCount: question.options.count, elementsInOneRow: 1)!
        
    }
}
