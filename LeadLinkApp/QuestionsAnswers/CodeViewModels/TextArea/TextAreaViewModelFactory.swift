//
//  TextAreaViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class TextAreaViewModelFactory: NSObject, GetViewModelProtocol {
    
    private let viewmodel: TextAreaViewModel
    func getViewModel() -> QuestionPageViewModelProtocol {
        return viewmodel
    }
    
    init(questionInfo: PresentQuestionInfoProtocol) {
        
        let question = questionInfo.getQuestion()
        let answer = questionInfo.getAnswer()
        
        let inputText = answer?.content.first ?? ""
        let placeholderText = question.description
        
        let labelFactory = LabelFactory(text: question.headlineText, width: allowedQuestionsWidth)
        let textViewFactory = TextViewFactory(inputText: inputText,
                                              placeholderText: placeholderText,
                                              questionId: questionInfo.getQuestion().id,
                                              width: allowedQuestionsWidth)
        
        let textView = textViewFactory.getView().findViews(subclassOf: UITextView.self).first!
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120.0).isActive = true
        
        let factory = LabelAndTextViewFactory(labelFactory: labelFactory, textViewFactory: textViewFactory)
        
        self.viewmodel = TextAreaViewModel(questionInfo: questionInfo, textAreaViewFactory: factory)
    }
}
