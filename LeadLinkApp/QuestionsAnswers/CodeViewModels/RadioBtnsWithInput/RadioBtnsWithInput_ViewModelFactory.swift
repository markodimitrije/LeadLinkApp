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
    
    init(surveyQuestion: SurveyQuestionProtocol) {
        let question = surveyQuestion.getQuestion()
        let answer = surveyQuestion.getAnswer()
        
        let radioBtnsFactory = RadioBtns_ViewFactory(question: question, answer: answer)
        
        let textAnswer = !question.qOptions.contains(answer?.content.last ?? "") ? answer?.content.last : ""
        let textViewFactory = TextViewFactory(inputText: textAnswer ?? "",
                                              placeholderText: question.qOptions.last ?? "",
                                              questionId: surveyQuestion.getQuestion().qId)
        
        let mainFactory = RadioBtnsWithInput_ViewFactory(radioBtnsFactory: radioBtnsFactory,
                                                         textViewFactory: textViewFactory)
        
        let viewmodel = RadioBtnsWithInputViewModel(surveyQuestion: surveyQuestion,
                                                    radioBtnsWithInputViewFactory: mainFactory)
        
        self.viewmodel = viewmodel
    }
    
}

