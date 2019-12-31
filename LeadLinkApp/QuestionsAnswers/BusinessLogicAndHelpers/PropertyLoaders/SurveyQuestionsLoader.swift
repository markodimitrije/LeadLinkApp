//
//  SurveyQuestionsLoader.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 19/08/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol SurveyQuestionsProviding {
    func getSurveyQuestions() -> [SurveyQuestionProtocol]
}

class SurveyQuestionsLoader: SurveyQuestionsProviding  {
    
    private var surveyInfo: SurveyInfo?
    private var surveyQuestions = [SurveyQuestionProtocol]()
    
    init(surveyInfo: SurveyInfo?) {
        self.surveyInfo = surveyInfo
        loadSurveyQuestions()
    }
    
    private func loadSurveyQuestions() {
        
        guard let surveyInfo = surveyInfo else {return}
        
        let questions = surveyInfo.campaign.questions
        let rAnswers = surveyInfo.answers.map { myAnswer -> RealmAnswer in
            let rAnswer = RealmAnswer()
            rAnswer.updateWith(answer: myAnswer)
            return rAnswer
        }
        
        self.surveyQuestions = questions.compactMap { question -> SurveyQuestion? in
            let rAnswer = rAnswers.first(where: {$0.questionId == question.id})
            let answer = MyAnswer(realmAnswer: rAnswer)
            return SurveyQuestion.init(question: question, answer: answer, code: surveyInfo.code)
        }
        
    }
    
    // MARK:- API
    func getSurveyQuestions() -> [SurveyQuestionProtocol] {
        return surveyQuestions
    }
}
