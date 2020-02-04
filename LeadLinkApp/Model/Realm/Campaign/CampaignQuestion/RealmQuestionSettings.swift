//
//  RealmQuestionSettings.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 18/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RealmSwift

public class RealmQuestionSettings: Object {
    
    @objc dynamic var id = 0
    var options = List<String>()
    
    func updateWith(settings: QuestionSettingsProtocol, question: QuestionProtocol) {
        let compositeId = "\(question.qCampaignId)" + "\(question.qId)"
        self.id = Int(compositeId)!
        let newOptions = settings.options ?? [ ]
        self.options.removeAll()
        self.options.append(objectsIn: newOptions)
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}
