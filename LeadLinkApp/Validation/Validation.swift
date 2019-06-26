//
//  Validation.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 17/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct Validation {
    
    // API
    var questionsFormIsValid: Bool {
//        return hasValidEmail && hasCheckedTermsAndConditions // hard-coded on
        return true // hard-coded on
    }
    
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
        
        print("termsAnswer.isOn = \(String(describing: termsAnswer))")
    }
    
}

class EmailValidator {
    
    func isValidEmail(testStr:String?) -> Bool {
        guard let testStr = testStr else {return false}
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
