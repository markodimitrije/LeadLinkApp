//
//  CampaignsMutableRepoFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 25/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

class CampaignsMutableRepoFactory {
    static func make() -> ICampaignsMutableRepository {
        CampaignsMutableRepository()
    }
}
