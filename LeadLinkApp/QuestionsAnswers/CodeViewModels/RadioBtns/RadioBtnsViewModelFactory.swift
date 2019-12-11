//
//  RadioBtnsViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

class RadioBtnsViewModelFactory: GetViewModelProtocol {
    
    private let viewmodel: RadioBtnsViewModel
    func getViewModel() -> QuestionPageViewModelProtocol {
        return viewmodel
    }
    
    init(questionInfo: PresentQuestionInfoProtocol) {
        let question = questionInfo.getQuestion()
        let answer = questionInfo.getAnswer()
        
        let radioBtnsFactory = RadioBtns_ViewFactory(question: question, answer: answer)
        
        let viewmodel = RadioBtnsViewModel(questionInfo: questionInfo, radioBtnsFactory: radioBtnsFactory)
        
        self.viewmodel = viewmodel
    }
}
