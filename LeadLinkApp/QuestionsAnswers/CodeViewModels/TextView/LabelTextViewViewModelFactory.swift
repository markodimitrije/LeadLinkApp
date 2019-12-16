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
    
    init(questionInfo: PresentQuestionInfoProtocol) {
        let question = questionInfo.getQuestion()
        
        let labelFactory = LabelFactory(text: question.headlineText, width: allowedQuestionsWidth)
        var textFactory: TextInputViewFactoryProtocol!
        let textOption = questionInfo.getQuestion().options.first
        if textOption == "barcode" {
            textFactory = BarcodeTextViewFactory(inputText: questionInfo.getCode(),
                                                 width: allowedQuestionsWidth)
        } else if textOption == "email"{
            textFactory = EmailTextViewFactory(inputText: questionInfo.getAnswer()?.content.first ?? "",
                                               placeholderText: question.description,
                                               width: allowedQuestionsWidth)
        } else {
            textFactory = TextViewFactory(inputText: questionInfo.getAnswer()?.content.first ?? "",
                                          placeholderText: question.description,
                                          questionId: questionInfo.getQuestion().id,
                                          width: allowedQuestionsWidth)
        }
        
        let viewFactory = LabelAndTextInputViewFactory(labelFactory: labelFactory,
                                                       textInputViewFactory: textFactory)
        
        let labelTextViewItem = LabelTextView_ViewModel(questionInfo: questionInfo, viewFactory: viewFactory)
        
        self.viewmodel = labelTextViewItem
        
        textFactory.getView().findViews(subclassOf: UITextView.self).first?.delegate = self.viewmodel
    }
    
}
