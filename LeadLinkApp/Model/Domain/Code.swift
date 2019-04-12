//
//  Code.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 20/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RealmSwift

public class Code: Codable {
    let value: String
    var campaign_id: Int
    var answers = [Answer]()
    
    init(value: String, campaign_id: Int) {
        self.value = value
        self.campaign_id = campaign_id
    }
    
    init(realmCode: RealmCode) {
        self.value = realmCode.value
        self.campaign_id = realmCode.campaign_id
        self.answers = realmCode.answers.toArray().map(Answer.init)
    }
    
}
