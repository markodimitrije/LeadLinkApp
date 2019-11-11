//
//  RealmDisclaimer.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 22/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Realm
import RealmSwift

class RealmDisclaimer: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var text: String = ""
    @objc dynamic var url: String = ""
    
    public func update(with disclaimer: Disclaimer, forCampaignId id: Int) {
        
        self.id = id
        self.text = disclaimer.text
        self.url = disclaimer.url
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
