//
//  AnswerInfo.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 13/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct AnswerIdentifer {
    var campaignId: Int
    var questionId: Int
    var code: String
    
    var compositeId: String {
        return "\(campaignId)" + "\(questionId)" + code
    }
    
    init(campaignId: Int, questionId: Int, code: String) {
        self.campaignId = campaignId
        self.questionId = questionId
        self.code = code
    }
}
