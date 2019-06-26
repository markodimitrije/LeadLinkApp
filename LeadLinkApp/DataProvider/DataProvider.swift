//
//  DataProvider.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 23/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class SurveyQuestion {
    
    var question: PresentQuestion
    //var answer: Answering?
    var answer: MyAnswer?
    
    init(question: Question, realmAnswer: RealmAnswer?) {
        self.question = PresentQuestion(question: question)
        self.answer = MyAnswer.init(realmAnswer: realmAnswer)
    }    
}
