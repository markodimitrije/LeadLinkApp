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

public struct QuestionSettings: Codable {
    var options: [String]?
    
    init(realmSetting: RealmQuestionSettings) {
        //self.options = realmSetting.options.sorted()
        self.options = realmSetting.options.toArray()
    }
}

enum QuestionType: String {
    case radioBtn = "radio"//"radioBtn"
    case checkbox = "checkbox"
    case radioBtnWithInput = "radioBtnWithInput"
    case checkboxWithInput = "checkboxWithInput"
    case switchBtn = "switchBtn"
    case textField = "text"//"textField"
    case textArea = "textarea"
    case dropdown = "dropdown"// case textWithOptions = "textWithOptions"
    case termsSwitchBtn = "termsSwitchBtn"
}
