//
//  RealmAnswer.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 19/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RealmSwift

public class RealmAnswer: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var campaignId: Int = 0
    @objc dynamic var questionId: Int = 0
    @objc dynamic var code = ""
    @objc dynamic var type = ""
    var optionIds = List<Int>()
    var content = List<String>()
    
    func updateWith(answer: MyAnswerProtocol) {
        self.id = "\(answer.campaignId)" + "\(answer.questionId)" + answer.code
        self.campaignId = answer.campaignId
        self.questionId = answer.questionId
        self.code = answer.code
        self.type = answer.questionType
        
        if (answer.optionIds == nil) {
            self.optionIds.removeAll()
        } else {
            self.optionIds.removeAll()
            self.optionIds.append(objectsIn: answer.optionIds!)
        }
        
        self.content.removeAll();
        self.content.append(objectsIn: answer.content)
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
}
