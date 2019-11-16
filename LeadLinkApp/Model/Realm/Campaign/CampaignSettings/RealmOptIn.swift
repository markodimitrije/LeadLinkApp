//
//  RealmOptIn.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 09/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RealmSwift

class RealmOptIn: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var text: String = ""
    @objc dynamic var url: String = ""
    
    public func update(with optIn: OptIn, forCampaignId campaignId: Int) {
        
        self.id = campaignId
        self.text = optIn.text
        self.url = optIn.url
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
