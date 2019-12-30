//
//  SurveyQuestionsLoader.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 19/08/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol SurveyQuestionsProviding {
    //func getQuestions() -> [SurveyQuestion]
    func getQuestionInfos() -> [PresentQuestionInfoProtocol]
}

class SurveyQuestionsLoader: SurveyQuestionsProviding  {
    
    private var surveyInfo: SurveyInfo?
    private var questionInfos = [PresentQuestionInfoProtocol]()
    
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
        
        self.questionInfos = questions.compactMap { question -> PresentQuestionInfo? in
            let rAnswer = rAnswers.first(where: {$0.questionId == question.id})
            let answer = MyAnswer(realmAnswer: rAnswer)
            return PresentQuestionInfo.init(question: question, answer: answer, code: surveyInfo.code)
        }
        
    }
    
    // MARK:- API
//    func getQuestions() -> [SurveyQuestion] {
//        return questions
//    }
    func getQuestionInfos() -> [PresentQuestionInfoProtocol] {
        return questionInfos
    }
}

