//
//  RealmQuestionSettings.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 18/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

public class RealmQuestionSettings: Object {
    
    @objc dynamic var id = 0
    var options = List<String>()
    
    func updateWith(settings: QuestionSettings, question: Question) {
        let compositeId = "\(question.campaign_id)" + "\(question.id)"
        self.id = Int(compositeId)!
        let newOptions = settings.options ?? [ ]
        self.options.removeAll()
        self.options.append(objectsIn: newOptions)
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}
