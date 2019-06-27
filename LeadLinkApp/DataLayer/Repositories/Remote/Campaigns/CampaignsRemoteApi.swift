//
//  RemoteApi.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

public protocol CampaignsRemoteAPI {
    func getCampaignsWithQuestions(userSession: UserSession) -> Promise<CampaignResults>
    func getImage(url: String) -> Promise<Data?>
}

public protocol CampaignsVersionChecking {
    func needsUpdate(newCampaignData json: String) -> Promise<Bool>
}

public struct CampaignsVersionChecker: CampaignsVersionChecking {
    
    var campaignsDataStore: CampaignsDataStore
    
    init(campaignsDataStore: CampaignsDataStore) {
        self.campaignsDataStore = campaignsDataStore
    }
    
    
    
    public func needsUpdate(newCampaignData json: String) -> Promise<Bool> {
        
        let realmString = campaignsDataStore.getCampaignsJsonString(requestName: WebRequestName.campaignsWithQuestions)

        return realmString.compactMap { str -> Bool? in
            
            return (realmString.value != json)
        }

    }
    
}

struct WebRequestName {
    static let campaignsWithQuestions = "campaigns?include=questions,organization"
}
