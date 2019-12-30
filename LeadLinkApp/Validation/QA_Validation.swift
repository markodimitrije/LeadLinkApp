//
//  QA_Validation.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 17/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct QA_Validation {
    
    private var surveyInfo: SurveyInfo
    private var questions: [QuestionProtocol]
    private var answers: [MyAnswerProtocol]
    
    // MARK:- API
    var questionsFormIsValid: Bool {
        return hasValidEmail && hasCheckedTermsAndConditions
        //return true // hard-coded on
    }
    
    var invalidFieldQuestion: QuestionProtocol? {
        if !hasValidEmail {
            return questions.first(where: { question -> Bool in
                question.qOptions.first == "email"
            })
        } else if !hasCheckedTermsAndConditions {
            return questions.first(where: { question -> Bool in
                question.qType == .termsSwitchBtn
            })
        }
        return nil
    }
    
    // MARK:- Private
    
    private let emailValidator = EmailValidator()
    
    private var emailAnswer: MyAnswerProtocol?
    private var termsAnswer: MyAnswerProtocol?
    
    private var hasValidEmail: Bool {
        return emailAnswer != nil
//        return true // hard-coded
    }
    private var hasCheckedTermsAndConditions: Bool {
        if termsAnswer == nil {
            return false
        }
        //return termsAnswer!.optionIds?.first != nil // indexes su u optionIds ako su checked
        //return (termsAnswer!.optionIds?.first == 1) ? true : false
        return termsAnswer!.content.first == "true" ? true : false
    }
    
    init(surveyInfo: SurveyInfo, questions: [QuestionProtocol], answers: [MyAnswerProtocol]) {
        
        self.surveyInfo = surveyInfo
        self.questions = questions
        self.answers = answers
        
        func loadEmailAndTermsAnswers() {
            
            self.emailAnswer = answers.first(where: { answer -> Bool in
                emailValidator.isValidEmail(testStr: answer.content.first)
            })
            
            let actualTermsAnswer = answers.first(where: { answer -> Bool in
                return answer.questionType == QuestionType.termsSwitchBtn.rawValue

            })
                
            self.termsAnswer = actualTermsAnswer ?? nil
        }
        
        loadEmailAndTermsAnswers()
        
    }
    
}
