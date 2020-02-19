//
//  NoEmailAndTerms_QA_Validation.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 19/02/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct NoEmailAndTerms_QA_Validation: QA_ValidationProtocol {
    
    var invalidFieldQuestion: QuestionProtocol? { return nil }
   
    func isQuestionsFormValid(answers: [MyAnswerProtocol]) -> Bool {
        return true
    }
}
