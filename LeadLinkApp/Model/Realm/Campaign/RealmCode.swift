//
//  RealmCode.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 20/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCode: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var value: String = ""
    @objc dynamic var campaign_id: Int = 0
    var answers = List<RealmAnswer>()
    
    func update(with code: Code) {
        self.value = code.value
        self.campaign_id = code.campaign_id
        self.id = "\(self.campaign_id)" + self.value 
        self.answers.append(objectsIn: code.answers.map(RealmAnswer.init))
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
