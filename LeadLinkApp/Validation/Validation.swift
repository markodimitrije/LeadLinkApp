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
        return hasValidEmail && hasCheckedTermsAndConditions // hard-coded on
//        return hasValidEmail
    }
    
    private let emailValidator = EmailValidator()
    
    private var emailAnswer: MyAnswer?
    private var termsAnswer: MyAnswer?
    
    private var hasValidEmail: Bool {
        return emailAnswer != nil
    }
    private var hasCheckedTermsAndConditions: Bool {
        if termsAnswer == nil {return true}
        return termsAnswer!.optionIds?.first != nil // indexes su u optionIds ako su checked
    }
    
    init(questions: [SingleQuestion], answers: [MyAnswer]) {
        self.emailAnswer = answers.first(where: { answer -> Bool in
            emailValidator.isValidEmail(testStr: answer.content.first)
        })
        
        let termsQuestion = questions.first { question -> Bool in
            question.question.type == .termsSwitchBtn
        }
        
        if let terms = termsQuestion {
            self.termsAnswer = answers.first(where: { answer -> Bool in
                answer.questionId == terms.question.id
            })
        }
        
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
