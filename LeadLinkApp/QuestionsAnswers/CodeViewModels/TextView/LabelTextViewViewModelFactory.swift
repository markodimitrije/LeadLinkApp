//
//  LabelTextFieldViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class LabelTextViewViewModelFactory: GetViewModelProtocol {
    
    private let viewmodel: LabelTextView_ViewModel
    func getViewModel() -> QuestionPageViewModelProtocol {
        return viewmodel
    }
    
    init(surveyQuestion: SurveyQuestionProtocol) {
        let question = surveyQuestion.getQuestion()
        
        let labelFactory = LabelFactory(text: question.qTitle, width: allowedQuestionsWidth)
        var textFactory: TextInputViewFactoryProtocol!
        let textOption = surveyQuestion.getQuestion().qOptions.first
        if textOption == "barcode" {
            textFactory = BarcodeTextViewFactory(inputText: surveyQuestion.getCode(),
                                                 width: allowedQuestionsWidth)
        } else if textOption == "email"{
            textFactory = EmailTextViewFactory(inputText: surveyQuestion.getAnswer()?.content.first ?? "",
                                               placeholderText: question.qDesc,
                                               width: allowedQuestionsWidth)
        } else {
            textFactory = TextViewFactory(inputText: surveyQuestion.getAnswer()?.content.first ?? "",
                                          placeholderText: question.qDesc,
                                          questionId: surveyQuestion.getQuestion().qId,
                                          width: allowedQuestionsWidth)
        }
        
        let viewFactory = LabelAndTextInputViewFactory(labelFactory: labelFactory,
                                                       textInputViewFactory: textFactory)
        
        let labelTextViewItem = LabelTextView_ViewModel(surveyQuestion: surveyQuestion, viewFactory: viewFactory)
        
        self.viewmodel = labelTextViewItem
        
        textFactory.getView().findViews(subclassOf: UITextView.self).first?.delegate = self.viewmodel
    }
    
}
