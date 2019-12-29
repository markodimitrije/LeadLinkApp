//
//  SurveyQuestion.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class SurveyQuestion {
    
    var question: PresentQuestion
    var answer: MyAnswer?
    
    init?(question: Question, realmAnswer: RealmAnswer?) {
        let isKnownQuestionType = QuestionType(rawValue: question.type) != nil
        guard isKnownQuestionType else {return nil}
        self.question = PresentQuestion(question: question)
        self.answer = MyAnswer.init(realmAnswer: realmAnswer)
    }
}
