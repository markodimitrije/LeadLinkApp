//
//  Answer.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 19/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

public struct Answer: Codable {
    var campaignId: Int
    var questionId: Int
    var code = ""
    var result = ""
    init(campaignId: Int, questionId: Int, code: String, result: String?) {
        self.campaignId = campaignId
        self.questionId = questionId
        self.code = code
        self.result = result ?? ""
    }
    
    init(realmAnswer: RealmAnswer) {
        self.campaignId = realmAnswer.campaignId
        self.questionId = realmAnswer.questionId
        self.code = realmAnswer.code
        self.result = realmAnswer.result
    }
}
