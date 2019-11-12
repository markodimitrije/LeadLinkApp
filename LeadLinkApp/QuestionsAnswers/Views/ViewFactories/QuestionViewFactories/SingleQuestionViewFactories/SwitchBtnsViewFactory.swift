//
//  SwitchBtnsViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class SwitchBtnsViewFactory {
    
    var sameComponentsFactory: SameComponentsFactory
    var questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory
    var bag: DisposeBag
    var delegate: UITextViewDelegate?
    
    init(sameComponentsFactory: SameComponentsFactory,
         questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory,
         bag: DisposeBag,
         delegate: UITextViewDelegate?) {
        
        self.sameComponentsFactory = sameComponentsFactory
        self.questionViewWithHeadlineLabelFactory = questionViewWithHeadlineLabelFactory
        self.bag = bag
        self.delegate = delegate
    }
    
    func getSwitchBtnsView(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (UIView, [UIView]) {
        
        let stackerView = self.viewStackerWithSwitchBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [LabelBtnSwitchView] in
            return (view as? OneRowStacker)?.components as? [LabelBtnSwitchView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.switcher.tag = $0.offset } // dodeli svakome unique TAG
        
        let finalView = (question.headlineText == "") ? stackerView : questionViewWithHeadlineLabelFactory.questionViewWithHeadlineLabel(question: question, aboveStackerView: stackerView).subviews.last as! ViewStacker
        
        return (finalView, btnViews)
    }
    
    private func viewStackerWithSwitchBtns(question: PresentQuestion, answer: Answering?, frame: CGRect) -> ViewStacker {
        
        return sameComponentsFactory.createStackWithSameComponents(
            ofType: LabelBtnSwitchView.self,
            componentsTotalCount: question.options.count,
            elementsInOneRow: 1)!
        
    }
}
