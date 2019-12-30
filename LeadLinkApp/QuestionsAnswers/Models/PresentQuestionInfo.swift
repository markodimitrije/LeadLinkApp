//
//  QuestionInfo.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct PresentQuestionInfo {
    
    private let question: PresentQuestion
    private let answer: MyAnswerProtocol?
    private let code: String
    
    init(question: PresentQuestion, answer: MyAnswerProtocol?, code: String) {
        self.question = question
        self.answer = answer
        self.code = code
    }
}

extension PresentQuestionInfo: PresentQuestionInfoProtocol {
    //func getQuestion() -> PresentQuestion {
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
