//
//  DropdownViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class DropdownViewModelFactory: GetViewModelProtocol {
    
    private let viewmodel: DropdownViewModel
    func getViewModel() -> QuestionPageViewModelProtocol {
        return viewmodel
    }
    
    init(surveyQuestion: SurveyQuestionProtocol) {
        let question = surveyQuestion.getQuestion()
        
        let labelFactory = LabelFactory(text: question.qTitle, width: allowedQuestionsWidth)
        let textViewFactory = TextViewFactory(inputText: surveyQuestion.getAnswer()?.content.first ?? "",
                                              placeholderText: question.qDesc,
                                              questionId: surveyQuestion.getQuestion().qId,
                                              width: allowedQuestionsWidth)

        let viewFactory = LabelAndTextInputViewFactory(labelFactory: labelFactory,
                                                       textInputViewFactory: textViewFactory)
        
        let textView = textViewFactory.getView() as? UITextView ?? textViewFactory.getView().findViews(subclassOf: UITextView.self).first!
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80.0).isActive = true
        
//        let viewFactory = LabelAndTextViewFactory(labelFactory: labelFactory,
//                                                  textViewFactory: textViewFactory)
//
//        let borderLayout = BorderLayout(cornerRadius: 5.0, borderWidth: 1.0, borderColor: .orange)
//        let embededFactory = WrapIntoBorderFactory(embededViewFactory: viewFactory, insets: UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0), borderLayout: borderLayout)
        
        let chooseOptionsViewControllerFactory =
            ChooseOptionsViewControllerFactory(appDependancyContainer: factory, surveyQuestion: surveyQuestion)
        
        let dropdownItem = DropdownViewModel(surveyQuestion: surveyQuestion,
                                             viewFactory: viewFactory,
                                             viewControllerFactory: chooseOptionsViewControllerFactory)
//        let dropdownItem = DropdownViewModel(surveyQuestion: surveyQuestion, viewFactory: embededFactory, viewControllerFactory: chooseOptionsViewControllerFactory)
    
        self.viewmodel = dropdownItem
    }
    
}
