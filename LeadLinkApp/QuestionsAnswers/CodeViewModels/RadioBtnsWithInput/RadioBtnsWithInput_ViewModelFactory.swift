//
//  RadioBtnsWithInput_ViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class RadioBtnsWithInput_ViewModelFactory: GetViewModelProtocol {
    
    private let viewmodel: RadioBtnsWithInputViewModel
    func getViewModel() -> QuestionPageViewModelProtocol {
        return viewmodel
    }
    
    init(questionInfo: PresentQuestionInfoProtocol) {
        let question = questionInfo.getQuestion()
        let answer = questionInfo.getAnswer()
        
        let radioBtnsFactory = RadioBtns_ViewFactory(question: question, answer: answer)
        let textViewFactory = TextViewFactory(inputText: answer?.content.first ?? "",
                                              placeholderText: question.qDesc,
                                              questionId: questionInfo.getQuestion().qId)
        
        let mainFactory = RadioBtnsWithInput_ViewFactory(radioBtnsFactory: radioBtnsFactory,
                                                         textViewFactory: textViewFactory)
        
        let viewmodel = RadioBtnsWithInputViewModel(questionInfo: questionInfo,
                                                    radioBtnsWithInputViewFactory: mainFactory)
        
        self.viewmodel = viewmodel
    }
    
}

