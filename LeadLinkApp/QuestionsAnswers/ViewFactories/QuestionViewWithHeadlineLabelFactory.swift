//
//  QuestionViewWithHeadlineLabelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class QuestionViewWithHeadlineLabelFactory {
    init() {
        
    }
    
    func questionViewWithHeadlineLabel(question: PresentQuestion, aboveStackerView stackerView: ViewStacker) -> UIView {
        
        return headlinedQuestionView(question: question, aboveStackerView: stackerView) // refactor u podfunc
        
    }
    
    private func headlinedQuestionView(question: PresentQuestion, aboveStackerView stackerView: ViewStacker) -> UIView {
        
        let titleLabel = getHeadlineLabel(question: question, aboveStackerView: stackerView)
        
        let finalView = UIView()
        finalView.addSubview(titleLabel)
        finalView.frame = CGRect.init(origin: stackerView.frame.origin, size: CGSize.init(width: stackerView.bounds.width, height: stackerView.bounds.height + titleLabel.bounds.height))
        let stackerShifted = stackerView
        stackerShifted.frame.origin.y += titleLabel.bounds.height
        finalView.insertSubview(stackerShifted, at: 1)
        
        return finalView
    }
    
    private func getHeadlineLabel(question: PresentQuestion, aboveStackerView stackerView: ViewStacker) -> UILabel {
        let titleLabel = UILabel.init(frame: CGRect.init(origin: stackerView.frame.origin,
                                                         size: CGSize.init(width: stackerView.bounds.width,
                                                                           height: tableHeaderFooterCalculator.getHeaderHeight())))
        
        titleLabel.numberOfLines = 0
        titleLabel.text = "  " + question.headlineText
        
        return titleLabel
    }
}
