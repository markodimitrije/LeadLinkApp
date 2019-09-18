//
//  RealmQuestion.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 08/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

public class RealmQuestion: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var campaign_id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var required: Bool = false
    @objc dynamic var desc: String = ""
    @objc dynamic var order: Int = 0
    
    @objc dynamic var group: String?
    var element_id: Int?
    @objc dynamic var settings: RealmQuestionSettings! = RealmQuestionSettings.init()
    
    func updateWith(question: Question) {
        self.id = question.id
        self.campaign_id = question.campaign_id
        self.title = question.title
        self.type = question.type
        self.group = question.group
        self.required = question.required
        self.desc = question.description ?? ""
        self.order = question.order
        self.element_id = question.element_id
        
        self.settings?.updateWith(settings: question.settings, question: question)
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
}

public class RealmQuestionSettings: Object {
    
    @objc dynamic var id = 0
    var options = List<String>()
    
    func updateWith(settings: QuestionSettings, question: Question) {
        let compositeId = "\(question.campaign_id)" + "\(question.id)"
        self.id = Int(compositeId)!
        let options = settings.options ?? [ ]
        self.options.append(objectsIn: options)
    }
    
}
