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
    var group: String?
    var required: Bool
    var description: String?
    var order: Int
    var element_id: Int?
    var settings: QuestionSettings
    
    init(realmQuestion: RealmQuestion) {
        self.id = realmQuestion.id
        self.campaign_id = realmQuestion.campaign_id
        self.title = realmQuestion.title
        self.type = realmQuestion.type
        self.group = realmQuestion.group
        self.required = realmQuestion.required
        self.description = realmQuestion.desc
        
        self.order = realmQuestion.order
        self.element_id = realmQuestion.element_id
        
        self.settings = QuestionSettings.init(realmSetting: realmQuestion.settings!)
    }
}

extension Question: QuestionProtocol {
    func getId() -> Int {
        return self.id
    }
    
    func getCampaignId() -> Int {
        return self.campaign_id
    }
    
    func getType() -> QuestionType {
        return QuestionType(rawValue: type)!
    }
    
    func getGroup() -> String {
        return self.group ?? ""
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getDesc() -> String {
        return self.description ?? ""
    }
    
    func getOrder() -> Int {
        return self.order
    }
    
    func getElementId() -> Int? {
        return self.element_id
    }
    
    func getSettings() -> QuestionSettings {
        return self.settings
    }
    
    func getOptions() -> [String] {
        return self.settings.options ?? [ ]
    }
    
}
