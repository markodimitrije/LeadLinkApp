//
//  CampaignsVersionChecker.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit

public struct CampaignsVersionChecker: CampaignsVersionChecking {
    
    var campaignsDataStore: CampaignsDataStore
    
    init(campaignsDataStore: CampaignsDataStore) {
        self.campaignsDataStore = campaignsDataStore
    }
    
    public func needsUpdate(newJson json: String) -> Promise<Bool> {
        
        let realmString = campaignsDataStore.getCampaignsJsonString(requestName: WebRequestName.campaignsWithQuestions)

        return realmString.compactMap { str -> Bool? in
            print("needsUpdate(newJson = \(realmString.value != json)")
            //return true // hard-coded
            return (realmString.value != json)
        }

    }
    
}
