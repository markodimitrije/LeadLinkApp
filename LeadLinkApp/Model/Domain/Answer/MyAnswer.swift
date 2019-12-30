//
//  MyAnswer.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 08/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

public struct MyAnswer: Codable, MyAnswerProtocol {//Answering, Codable {
    
    var campaignId = 0
    var questionId = 0
    var code = ""
    var id = ""
    var content = [String]()
    var optionIds: [Int]?
    var questionType = ""
    
    var isEmpty: Bool {
        return content.isEmpty || (content.first! == "")
    }
    
    var compositeId: String {
        return "\(campaignId)" + "\(questionId)" + code
    }
    
    init(question: QuestionProtocol, code: String, content: [String], optionIds: [Int]?) {
        self.campaignId = question.qCampaignId
        self.questionId = question.qId
        self.code = code
        self.id = "\(campaignId)" + "\(questionId)" + code
        self.content = content
        self.optionIds = optionIds
        self.questionType = question.qType.rawValue
    }
    
    init?(realmAnswer: RealmAnswer?) {
        guard let realmAnswer = realmAnswer, realmAnswer.id != "" else {
            return nil
        }
        self.campaignId = realmAnswer.campaignId
        self.questionId = realmAnswer.questionId
        self.code = realmAnswer.code
        self.id = realmAnswer.id
        self.content = Array(realmAnswer.content)
        self.optionIds = Array(realmAnswer.optionIds)
        self.questionType = realmAnswer.type
    }
    
    static func emptyContent(question: QuestionProtocol) -> MyAnswer {
        return MyAnswer.init(question: question,
                             code: "",
                             content: [],
                             optionIds: [])
    }
    
}

extension MyAnswer: Hashable {
    public static func == (lhs: MyAnswer, rhs: MyAnswer) -> Bool {
        return lhs.compositeId == rhs.compositeId
    }
    
    public func hash(into hasher: inout Hasher) {
        let value = Int(self.compositeId) ?? 0
        hasher.combine(value)
    }
}
