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
    var content = [String]()
    var code = ""
    
    var id: String {
        return code + "\(questionId)"
    }
    
    init(campaignId: Int, questionId: Int, code: String, content: [String] = [ ]) {
        self.campaignId = campaignId
        self.questionId = questionId
        self.code = code
        self.content = content
    }
    
    init?(realmAnswer: RealmAnswer?) {
        guard let realmAnswer = realmAnswer else {
            return nil
        }
        self.campaignId = realmAnswer.campaignId
        self.questionId = realmAnswer.questionId
        self.code = realmAnswer.code
        self.content = Array(realmAnswer.content)
    }
}
