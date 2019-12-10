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
    
    init(questionInfo: PresentQuestionInfoProtocol) {
        let question = questionInfo.getQuestion()
        
        let labelFactory = LabelFactory(text: question.headlineText, width: allowedQuestionsWidth)
        let textViewFactory = TextViewFactory(inputText: questionInfo.getAnswer()?.content.first ?? "", placeholderText: question.description, width: allowedQuestionsWidth)
        
//        let labelFactory = LabelFactory(text: question.headlineText, width: allowedQuestionsWidth - 8.0)
//        let textViewFactory = TextViewFactory(inputText: questionInfo.getAnswer()?.content.first ?? "", placeholderText: question.description ?? "", width: allowedQuestionsWidth - 8.0)

        let viewFactory = LabelAndTextViewFactory(labelFactory: labelFactory,
                                                  textViewFactory: textViewFactory)
        
        let textView = textViewFactory.getView().findViews(subclassOf: UITextView.self).first!
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80.0).isActive = true
        
//        let viewFactory = LabelAndTextViewFactory(labelFactory: labelFactory,
//                                                  textViewFactory: textViewFactory)
//
//        let borderLayout = BorderLayout(cornerRadius: 5.0, borderWidth: 1.0, borderColor: .orange)
//        let embededFactory = WrapIntoBorderFactory(embededViewFactory: viewFactory, insets: UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0), borderLayout: borderLayout)
        
        let dropdownItem = DropdownViewModel(presentQuestionInfo: questionInfo, viewFactory: viewFactory)
//        let dropdownItem = DropdownViewModel(presentQuestionInfo: questionInfo, viewFactory: embededFactory)
        
        self.viewmodel = dropdownItem
    }
    
}
