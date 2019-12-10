//
//  LabelTextFieldViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class LabelTextFieldViewModelFactory: GetViewModelProtocol {
    
    private let viewmodel: LabelTextFieldViewModel
    func getViewModel() -> QuestionPageViewModelProtocol {
        return viewmodel
    }
    
    init(questionInfo: PresentQuestionInfoProtocol) {
        let question = questionInfo.getQuestion()
        
        let labelFactory = LabelFactory(text: question.headlineText, width: allowedQuestionsWidth)
        let textViewFactory = TextViewFactory(inputText: questionInfo.getAnswer()?.content.first ?? "", placeholderText: question.description, width: allowedQuestionsWidth)
        
        let viewFactory = LabelAndTextViewFactory(labelFactory: labelFactory,
                                                  textViewFactory: textViewFactory)
        
        let labelTextViewItem = LabelTextFieldViewModel(questionInfo: questionInfo, viewFactory: viewFactory)
        
        self.viewmodel = labelTextViewItem
    }
    
}

