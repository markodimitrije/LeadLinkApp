//
//  SurveyQuestion.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct SurveyQuestion {
    
    private let question: QuestionProtocol
    private let answer: MyAnswerProtocol?
    private let code: String
    
    init(question: QuestionProtocol, answer: MyAnswerProtocol?, code: String) {
        self.question = question
        self.answer = answer
        self.code = code
    }
}

extension SurveyQuestion: SurveyQuestionProtocol {
    func getQuestion() -> QuestionProtocol {
        return self.question
    }
    func getAnswer() -> MyAnswerProtocol? {
        return self.answer
    }
    func getCode() -> String {
        return self.code
    }
}
