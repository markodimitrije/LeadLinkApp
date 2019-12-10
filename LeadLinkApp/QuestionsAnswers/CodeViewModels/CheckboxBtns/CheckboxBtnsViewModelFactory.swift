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
    
    init(questionInfo: PresentQuestionInfoProtocol) {
        let question = questionInfo.getQuestion()
        let answer = questionInfo.getAnswer()
        
        let checkboxBtnsFactory = CheckboxBtnsFactory(question: question, answer: answer)
        
        let viewmodel = CheckboxBtnsViewModel(questionInfo: questionInfo, checkboxBtnsFactory: checkboxBtnsFactory)
        
        self.viewmodel = viewmodel
    }
}
