//
//  Validation.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 17/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct Validation {
    
    private let emailValidator = EmailValidator()
    
    private var emailAnswer: MyAnswer?
    
    var hasValidEmail: Bool {
        return emailAnswer != nil
    }
    
    init(answers: [MyAnswer]) {
        self.emailAnswer = answers.first(where: { answer -> Bool in
            emailValidator.isValidEmail(testStr: answer.content.first)
        })
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
