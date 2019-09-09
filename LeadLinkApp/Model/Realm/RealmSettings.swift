//
//  RealmSettings.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 09/09/2019.
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
