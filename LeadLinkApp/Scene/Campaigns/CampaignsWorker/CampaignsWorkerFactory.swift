//
//  CampaignsWorkerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 25/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

class CampaignsWorkerFactory {
    static func make() -> ICampaignsWorker {
        CampaignsWorker(dataStore: CampaignsMutableRepoFactory.make(),
                        userSessionDataStore: FileUserSessionDataStore(),
                        remoteAPI: CampaignsWithQuestionsRemoteAPI.shared)
    }
}
