//
//  PresentQuestion.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 13/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

//public struct Question: Codable {
//var id: Int
//var campaign_id: Int
//var title: String
//var type: String
//var group: String?
//var required: Bool
//var description: String?
//var order: Int
//var element_id: Int?
//var settings: QuestionSettings

struct PresentQuestion {
    var id: Int
    var campaignId: Int
    var type: QuestionType
    var headlineText = ""
    var group: String?
    var order: Int = 0
    var options = [String]()
    var multipleSelection = false
    var description: String = ""
    init(question: Question) {
        let type = QuestionType(rawValue: question.type)!
        self.id = question.id
        self.campaignId = question.campaign_id
        self.type = type
        self.headlineText = question.title
        self.group = question.group
        self.order = question.order
        self.options = question.settings.options ?? [ ]
        self.description = question.description ?? ""
        if (type == .dropdown) {
            self.multipleSelection = !options.contains("country")
        }
    }
}

extension PresentQuestion: Comparable {
    static func < (lhs: PresentQuestion, rhs: PresentQuestion) -> Bool {
        return lhs.order < rhs.order
    }
}
