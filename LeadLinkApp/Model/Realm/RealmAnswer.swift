//
//  RealmAnswer.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 19/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

public class RealmAnswer: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var campaignId: Int = 0
    @objc dynamic var questionId: Int = 0
    @objc dynamic var code = ""
    @objc dynamic var result = ""
    
    func updateWith(answer: Answer) {
        self.campaignId = answer.campaignId
        self.questionId = answer.questionId
        self.code = answer.code
        self.result = answer.result
        id = "\(campaignId)" + "\(questionId)"
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
}
