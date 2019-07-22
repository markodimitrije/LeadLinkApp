//
//  RealmDisclaimer.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 22/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Realm
import RealmSwift

class RealmSettings: Object {
    
    @objc dynamic var disclaimer: RealmDisclaimer!
    @objc dynamic var optIn: RealmOptIn!
    
    public func update(with settings: Settings, forCampaignId id: Int) {
        
        let realmSettings = RealmDisclaimer()
        realmSettings.update(with: settings.disclaimer, forCampaignId: id)
        
        let realmOptIn = RealmOptIn()
        realmOptIn.update(with: settings.optIn, forCampaignId: id)
        
        self.disclaimer = realmSettings
        self.optIn = realmOptIn
        
    }
}

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

class RealmOptIn: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var text: String = ""
    @objc dynamic var url: String = ""
    
    public func update(with optIn: OptIn, forCampaignId id: Int) {
        
        self.id = id
        self.text = optIn.text
        self.url = optIn.url
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
