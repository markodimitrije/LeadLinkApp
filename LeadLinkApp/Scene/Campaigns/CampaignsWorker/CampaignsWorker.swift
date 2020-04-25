//
//  CampaignsWorker.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 25/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit

protocol ICampaignsWorker {
    func getCampaignsAndQuestions() -> Promise<Bool>
}

extension CampaignsWorker: ICampaignsWorker {
    func getCampaignsAndQuestions() -> Promise<Bool> {
        guard let userSession = userSessionDataStore.readUserSession().value else {
            return Promise.init(error: CampaignError.userNotLoggedInError)
        }
        let camRes = remoteAPI.getCampaignsWithQuestions(userSession: userSession)
        let arr = camRes.map {$0.campaignsWithQuestions}
        let campaigns = arr.mapValues { $0.0 }
        return campaigns.then(self.dataStore.save).map {_ in return true}
    }
}

struct CampaignsWorker {
    let dataStore: CampaignsDataStore
    let userSessionDataStore: UserSessionDataStore
    let remoteAPI: CampaignsRemoteAPI
}
