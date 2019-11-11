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
    private var questions: [SurveyQuestion]
    private var answers: [MyAnswer]
    
    // MARK:- API
    var questionsFormIsValid: Bool {
        return hasValidEmail && hasCheckedTermsAndConditions
        //return true // hard-coded on
    }
    
    var invalidFieldQuestion: PresentQuestion? {
        if !hasValidEmail {
            return questions.first(where: { question -> Bool in
                question.question.options.first == "email"
            })?.question
        } else if !hasCheckedTermsAndConditions {
            return questions.first(where: { question -> Bool in
                question.question.type == .termsSwitchBtn
            })?.question
        }
        return nil
    }
    
    // MARK:- Private
    
    private let emailValidator = EmailValidator()
    
    private var emailAnswer: MyAnswer?
    private var termsAnswer: MyAnswer?
    
    private var hasValidEmail: Bool {
        return emailAnswer != nil
//        return true // hard-coded
    }
    private var hasCheckedTermsAndConditions: Bool {
        if termsAnswer == nil {
            return false
        }
        return termsAnswer!.optionIds?.first != nil // indexes su u optionIds ako su checked
    }
    
    init(surveyInfo: SurveyInfo, questions: [SurveyQuestion], answers: [MyAnswer]) {
        
        self.surveyInfo = surveyInfo
        self.questions = questions
        self.answers = answers
        
        func loadEmailAndTermsAnswers() {
            self.emailAnswer = answers.first(where: { answer -> Bool in
                emailValidator.isValidEmail(testStr: answer.content.first)
            })
            
            let termsQuestion = questions.first { question -> Bool in
                question.question.type == .termsSwitchBtn
            }
            
            if let terms = termsQuestion {
                
                let actualAnswer = answers.first(where: { answer -> Bool in
                    return answer.questionId == terms.question.id &&
                        answer.code == surveyInfo.code
                })
                
                self.termsAnswer = actualAnswer ?? nil
                
            }
        }
        
        loadEmailAndTermsAnswers()
        
    }
    
}
