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
    var type: String
    var headlineText = ""
    var group: String
    var order: Int = 0
    var settings: QuestionSettings
    var options = [String]()
    var multipleSelection = false
    var description: String = ""
    init(question: Question) {
        self.id = question.id
        self.campaignId = question.campaign_id
        self.type = question.type
        self.headlineText = question.title
        self.group = question.group
        self.order = question.order
        self.settings = question.settings
        self.options = question.settings.options ?? [ ]
        self.description = question.description ?? ""
        
        if (type == "dropdown") {
            self.multipleSelection = !options.contains("country")
        }
    }
}

extension PresentQuestion: Comparable {
    static func == (lhs: PresentQuestion, rhs: PresentQuestion) -> Bool {
        lhs.id == rhs.id &&
        lhs.campaignId == rhs.campaignId &&
        lhs.order == rhs.order &&
        lhs.group == rhs.group &&
        lhs.headlineText == rhs.headlineText &&
        lhs.description == rhs.description &&
        lhs.options == rhs.options
    }
    
    static func < (lhs: PresentQuestion, rhs: PresentQuestion) -> Bool {
        return lhs.order < rhs.order
    }
}

extension PresentQuestion: QuestionProtocol {
    var qType: QuestionType {
        QuestionType(rawValue: type)!
    }
    
    var qId: Int {
        self.id
    }
    
    var qCampaignId: Int {
        self.campaignId
    }
    
    var qTitle: String {
        self.headlineText
    }
    
    var qDesc: String {
        self.description
    }
    
    var qGroup: String {
        self.group
    }
    
    var qOrder: Int {
        self.order
    }
    
    var qSettings: QuestionSettings {
        self.settings
    }
    
    var qOptions: [String] {
        self.options
    }
    
    var qMultipleSelection: Bool {
        return multipleSelection
    }
    
}
