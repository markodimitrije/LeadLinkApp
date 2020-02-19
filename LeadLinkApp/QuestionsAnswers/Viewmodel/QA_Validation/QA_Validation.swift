//
//  QA_Validation.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 17/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol QA_ValidationProtocol {
    func isQuestionsFormValid(answers: [MyAnswerProtocol]) -> Bool
    var invalidFieldQuestion: QuestionProtocol? { get }
}

class QA_Validation: QA_ValidationProtocol {
    
    private var campaign: CampaignProtocol
    private var questions: [QuestionProtocol] { return campaign.questions }
    
    // MARK:- API
    func isQuestionsFormValid(answers: [MyAnswerProtocol]) -> Bool {
        self.loadEmailAndTermsAnswers(answers: answers)
        return hasValidEmail && hasCheckedTermsAndConditions
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
        return emailAnswer != nil   // return true // hard-coded
    }
    private var hasCheckedTermsAndConditions: Bool {
        if termsAnswer == nil {
            return false
        }
        return termsAnswer!.content.first == "true" ? true : false
    }
    
    private func loadEmailAndTermsAnswers(answers: [MyAnswerProtocol]) {
        
        self.emailAnswer = answers.first(where: { answer -> Bool in
            emailValidator.isValidEmail(testStr: answer.content.first)
        })
        
        let actualTermsAnswer = answers.first(where: { answer -> Bool in
            return answer.questionType == QuestionType.termsSwitchBtn.rawValue

        })
            
        self.termsAnswer = actualTermsAnswer ?? nil
    }
    
    init(campaign: CampaignProtocol) {
        self.campaign = campaign
    }
    
}
