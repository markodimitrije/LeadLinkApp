//
//  CheckboxWithInputViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class CheckboxWithInputViewFactory: GetViewProtocol {
   
    private var myView: UIView!
    private var singleCheckboxBtnViewModels: [SingleCheckboxBtnViewModel]!

    func getView() -> UIView {
        return myView
    }
    
    func getViewModels() -> [SingleCheckboxBtnViewModel] {
        return self.singleCheckboxBtnViewModels
    }
    
    init(surveyQuestion: SurveyQuestionProtocol, labelFactory: LabelFactory, checkboxBtnsFactory: CheckboxBtnsFactory, textViewFactory: TextViewFactory) {
        
        let checkboxBtnsViewModels: [SingleCheckboxBtnViewModel] = checkboxBtnsFactory.getViewModels()
        self.singleCheckboxBtnViewModels = checkboxBtnsViewModels
        
        let checkboxBtnsViewStackView = checkboxBtnsFactory.getView()
        var checkboxBtnsViews: [UIView] = checkboxBtnsViewStackView.subviews
        
        let lastCheckboxBtnView = checkboxBtnsViews.removeLast()

        let singleCheckboxBtnsView = CodeVerticalStacker(views: checkboxBtnsViews).getView()
        
        let textView = textViewFactory.getView()
        
        let lastCheckboxBtnWithInputView = CodeHorizontalStacker(views: [lastCheckboxBtnView, textView], distribution: .fillEqually).getView()
        
        let labelView = labelFactory.getView()
        
        self.myView = CodeVerticalStacker(views: [labelView,
                                                  singleCheckboxBtnsView,
                                                  lastCheckboxBtnWithInputView]).getView()
        
        lastCheckboxBtnWithInputView.leadingAnchor.constraint(equalTo: lastCheckboxBtnWithInputView.superview!.leadingAnchor).isActive = true
        lastCheckboxBtnWithInputView.superview!.trailingAnchor.constraint(equalTo: lastCheckboxBtnWithInputView.trailingAnchor).isActive = true
        
    }
    
    private func getNonOptionTextAnswer(question: QuestionProtocol, answer: MyAnswerProtocol?) -> String {
        
        guard let answer = answer else {
            return question.qDesc
        }
        let contentNotContainedInOptions = answer.content.first(where: {!question.qOptions.contains($0)})
        return contentNotContainedInOptions ?? ""
    }
    
}

