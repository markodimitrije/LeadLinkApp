//
//  Question.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 08/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

public struct Questions: Codable {
    var data: [Question]
}

public struct Question: Codable {
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
    
    var qSettings: QuestionSettings {
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
