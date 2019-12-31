//
//  LabelTextFieldViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 16/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

import UIKit

class LabelPhoneTextField_ViewModelFactory: GetViewModelProtocol {
    
    private let viewmodel: LabelTextField_ViewModel
    func getViewModel() -> QuestionPageViewModelProtocol {
        return viewmodel
    }
    
    init(surveyQuestion: SurveyQuestionProtocol) {
        let question = surveyQuestion.getQuestion()
        
        let labelFactory = LabelFactory(text: question.qTitle, width: allowedQuestionsWidth)
        
        let textFieldFactory = PhoneTextFieldFactory(inputText: surveyQuestion.getAnswer()?.content.first ?? "",
                                                    placeholderText: question.qDesc,
                                                    width: allowedQuestionsWidth)
        
        let viewFactory = LabelAndTextInputViewFactory(labelFactory: labelFactory,
                                                       textInputViewFactory: textFieldFactory)
        
        let labelTextViewItem = LabelTextField_ViewModel(surveyQuestion: surveyQuestion, viewFactory: viewFactory)
        
        self.viewmodel = labelTextViewItem
        
        textFieldFactory.getView().findViews(subclassOf: UITextField.self).first?.delegate = self.viewmodel
    }
    
}
