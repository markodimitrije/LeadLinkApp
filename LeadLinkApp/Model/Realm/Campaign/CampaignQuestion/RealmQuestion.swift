//
//  RealmQuestion.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 08/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RealmSwift

public class RealmQuestion: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var campaign_id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var required: Bool = false
    @objc dynamic var desc: String = ""
    @objc dynamic var order: Int = 0
    
    @objc dynamic var group: String = ""
    var element_id: Int?
    @objc dynamic var settings: RealmQuestionSettings! = RealmQuestionSettings.init()
    
    func updateWith(question: QuestionProtocol) {
        self.id = question.qId
        self.campaign_id = question.qCampaignId
        self.title = question.qTitle
        self.type = question.qType.rawValue
        self.group = question.qGroup
        self.desc = question.qDesc
        self.order = question.qOrder
        
        self.settings.updateWith(settings: question.qSettings, question: question)
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
}
