//
//  SurveyQuestionsLoader.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 19/08/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol SurveyQuestionsProviding {
    func getQuestions() -> [SurveyQuestion]
}

class SurveyQuestionsLoader: SurveyQuestionsProviding  {
    
    private var surveyInfo: SurveyInfo?
    private var questions = [SurveyQuestion]()
    
    init(surveyInfo: SurveyInfo?) {
        self.surveyInfo = surveyInfo
        loadQuestions()
    }
    
    private func loadQuestions() {
        
        guard let surveyInfo = surveyInfo else {return}
        
        let questions = surveyInfo.campaign.questions
        let rAnswers = surveyInfo.answers.map { myAnswer -> RealmAnswer in
            let rAnswer = RealmAnswer()
            rAnswer.updateWith(answer: myAnswer)
            return rAnswer
        }
        
        self.questions = questions.map { question -> SurveyQuestion in
            let rAnswer = rAnswers.first(where: {$0.questionId == question.id})
            return SurveyQuestion.init(question: question, realmAnswer: rAnswer)
        }
        
    }
    
    // MARK:- API
    func getQuestions() -> [SurveyQuestion] {
        return questions
    }
}
