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
    var description: String
    var order: Int
    var element_id: Int?
    var settings: Setting
    
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

        self.settings = Setting.init(realmSetting: realmQuestion.setting!)
    }
}

public struct Setting: Codable {
    var options: [String]?
    
    init(realmSetting: RealmSetting) {
        self.options = realmSetting.options.sorted()
    }
}
