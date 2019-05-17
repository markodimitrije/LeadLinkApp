//
//  PresentQuestion.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 13/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct PresentQuestion {
    var id: Int
    var campaignId: Int
    var type: QuestionType
    var headlineText = ""
    var group: String?
    var order: Int = 0
    var inputTxt = ""
    var options = [String]()
    var multipleSelection = false
    init(question: Question) {
        let type = QuestionType(rawValue: question.type)!
        self.id = question.id
        self.campaignId = question.campaign_id
        self.type = type
        self.headlineText = question.title
        self.group = question.group
        self.order = question.order
        self.inputTxt = question.description
        self.options = question.settings.options ?? [ ]
        if (type == .dropdown) { // we actualy need two types: textOptionsSingleChoice and textOptionsMultipleChoice
            self.multipleSelection = false
        }
    }
}

extension PresentQuestion: Comparable {
    static func < (lhs: PresentQuestion, rhs: PresentQuestion) -> Bool {
        return lhs.order < rhs.order
    }
}
