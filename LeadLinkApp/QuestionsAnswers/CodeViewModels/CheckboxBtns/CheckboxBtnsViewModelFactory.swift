//
//  CheckboxBtnsViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class CheckboxBtnsViewModelFactory: GetViewModelProtocol {
    
    private let viewmodel: CheckboxBtnsViewModel
    func getViewModel() -> QuestionPageViewModelProtocol {
        return viewmodel
    }
    
    init(surveyQuestion: SurveyQuestionProtocol) {
        let question = surveyQuestion.getQuestion()
        let answer = surveyQuestion.getAnswer()
        
        let labelFactory = LabelFactory(text: question.qTitle, width: allowedQuestionsWidth)
        let checkboxBtnsFactory = CheckboxBtnsFactory(question: question, answer: answer)
        
        let viewmodel = CheckboxBtnsViewModel(surveyQuestion: surveyQuestion,
                                              labelFactory: labelFactory,
                                              checkboxBtnsFactory: checkboxBtnsFactory)
        
        self.viewmodel = viewmodel
    }
}
