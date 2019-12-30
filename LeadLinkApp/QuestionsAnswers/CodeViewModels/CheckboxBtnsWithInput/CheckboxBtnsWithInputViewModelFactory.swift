//
//  CheckboxBtnsWithInputViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class CheckboxBtnsWithInputViewModelFactory: GetViewModelProtocol {
    
    private let viewmodel: CheckboxInputViewModel
    func getViewModel() -> QuestionPageViewModelProtocol {
        return viewmodel
    }
    
    init(questionInfo: PresentQuestionInfoProtocol) {
        let question = questionInfo.getQuestion()
        let answer = questionInfo.getAnswer()
        
        let checkboxBtnsFactory = CheckboxBtnsFactory(question: question, answer: answer)
        let textViewFactory = TextViewFactory(inputText: answer?.content.last ?? "",
                                                  placeholderText: question.qDesc,
                                                  questionId: questionInfo.getQuestion().qId)
        let labelFactory = LabelFactory(text: question.qTitle, width: allowedQuestionsWidth)
        
        let mainFactory = CheckboxWithInputViewFactory(questionInfo: questionInfo,
                                                       labelFactory: labelFactory,
                                                       checkboxBtnsFactory: checkboxBtnsFactory,
                                                       textViewFactory: textViewFactory)
        
        let viewmodel = CheckboxInputViewModel(questionInfo: questionInfo, checkboxBtnsWithInputViewFactory: mainFactory)
        
        self.viewmodel = viewmodel
        
        let textView =
            textViewFactory.getView() as? UITextView ?? textViewFactory.getView().findViews(subclassOf: UITextView.self).first!
        
        textView.delegate = self.viewmodel
    }
    
}



