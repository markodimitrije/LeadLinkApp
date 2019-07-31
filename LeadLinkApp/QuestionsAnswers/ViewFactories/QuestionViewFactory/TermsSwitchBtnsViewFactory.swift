//
//  TermsSwitchBtnsViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class TermsSwitchBtnsViewFactory {
    
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
    
    func getTermsSwitchBtnsView(question: PresentQuestion,
                                answer: Answering?,
                                frame: CGRect) -> (UIView, [UIView]) {
        
        let stackerView = self.viewStackerWithTermsSwitch(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [TermsLabelBtnSwitchView] in
            return (view as? OneRowStacker)?.components as? [TermsLabelBtnSwitchView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.switcher.tag = $0.offset } // dodeli svakome unique TAG
        
        let finalView = question.headlineText != "" ? questionViewWithHeadlineLabelFactory.questionViewWithHeadlineLabel(question: question, aboveStackerView: stackerView).subviews.last as! ViewStacker : stackerView
        
        return (finalView, btnViews)
    }
    
    private func viewStackerWithTermsSwitch(question: PresentQuestion, answer: Answering?, frame: CGRect) -> ViewStacker {
        
        return sameComponentsFactory.createStackWithSameComponents(ofType: TermsLabelBtnSwitchView.self,
                                                                   componentsTotalCount: 1,
                                                                   elementsInOneRow: 1)!
    }
}
