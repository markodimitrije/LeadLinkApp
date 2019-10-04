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
    
    @objc dynamic var id = 0
    @objc dynamic var disclaimer: RealmDisclaimer?
    @objc dynamic var optIn: RealmOptIn?
    @objc dynamic var useScanditScanner: Bool = false
    @objc dynamic var showEmail: Bool = true
    
    public func update(with settings: Settings, forCampaignId id: Int) {
    
        self.id = id
        
        if let disclaimer = settings.disclaimer {
            let realmSettings = RealmDisclaimer()
            realmSettings.update(with: disclaimer, forCampaignId: id)
            self.disclaimer = realmSettings
        }
        
        if let optIn = settings.optIn {
            let realmOptIn = RealmOptIn()
            realmOptIn.update(with: optIn, forCampaignId: id)
            self.optIn = realmOptIn
        }
        
        if let useScanditScanner = settings.use_scandit_scanner {
            self.useScanditScanner = useScanditScanner
        }
        
        if let showEmail = settings.showEmail {
            self.showEmail = showEmail
        }
        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
