//
//  Question.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 08/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct Questions {
    var data: [QuestionProtocol]
}

struct Question: Codable {
    var id: Int
    var campaign_id: Int
    var title: String
    var type: String
    var group: String
    var description: String?
    var order: Int
    var settings: QuestionSettings
    
    init(realmQuestion: RealmQuestion) {
        self.id = realmQuestion.id
        self.campaign_id = realmQuestion.campaign_id
        self.title = realmQuestion.title
        self.type = realmQuestion.type
        self.group = realmQuestion.group
        self.description = realmQuestion.desc
        self.order = realmQuestion.order
        
        self.settings = QuestionSettings.init(realmSetting: realmQuestion.settings!)
    }
    
    init(questionResponse: QuestionResponseProtocol) {
        self.id = questionResponse.id
        self.campaign_id = questionResponse.campaign_id
        
        self.title = questionResponse.title
        self.type = questionResponse.type
        self.group = questionResponse.group
        self.description = questionResponse.description
        self.order = questionResponse.order
        self.settings = QuestionSettings(questionSettingsResponse: questionResponse.settings)
    }
    
}

extension Question: QuestionProtocol {
    
    var qId: Int {
        self.id
    }
    
    var qCampaignId: Int {
        self.campaign_id
    }
    
    var qTitle: String {
        self.title
    }
    
    var qDesc: String {
        self.description ?? ""
    }
    
    var qGroup: String {
        self.group
    }
    
    var qOrder: Int {
        self.order
    }
    
    var qSettings: QuestionSettingsProtocol {
        self.settings
    }
    
    var qOptions: [String] {
        self.settings.options ?? [ ]
    }
    
    var qType: QuestionType {
        QuestionType(rawValue: self.type)!
    }
    
    var qMultipleSelection: Bool {
        if qType == .dropdown {
            return !qOptions.contains("country")
        }
        return false
    }
    
}

extension Question: Comparable {
    public static func == (lhs: Question, rhs: Question) -> Bool {
        lhs.id == rhs.id &&
        lhs.campaign_id == rhs.campaign_id &&
        lhs.order == rhs.order &&
        lhs.type == rhs.type &&
        lhs.group == rhs.group &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.settings.options == rhs.settings.options
    }
    public static func < (lhs: Question, rhs: Question) -> Bool {
        return lhs.order < rhs.order
    }
}
