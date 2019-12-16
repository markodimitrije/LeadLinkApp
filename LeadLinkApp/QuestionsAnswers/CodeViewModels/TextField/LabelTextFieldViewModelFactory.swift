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
    
    init(questionInfo: PresentQuestionInfoProtocol) {
        let question = questionInfo.getQuestion()
        
        let labelFactory = LabelFactory(text: question.headlineText, width: allowedQuestionsWidth)
        
        let textFieldFactory = PhoneTextFieldFactory(inputText: questionInfo.getAnswer()?.content.first ?? "",
                                                    placeholderText: question.description,
                                                    width: allowedQuestionsWidth)
        
        let viewFactory = LabelAndTextInputViewFactory(labelFactory: labelFactory,
                                                       textInputViewFactory: textFieldFactory)
        
        let labelTextViewItem = LabelTextField_ViewModel(questionInfo: questionInfo, viewFactory: viewFactory)
        
        self.viewmodel = labelTextViewItem
        
        textFieldFactory.getView().findViews(subclassOf: UITextField.self).first?.delegate = self.viewmodel
    }
    
}
