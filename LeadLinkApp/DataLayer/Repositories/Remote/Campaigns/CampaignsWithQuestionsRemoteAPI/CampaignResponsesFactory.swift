//
//  CampaignResponsesFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol CampaignResponsesFactoryProtocol {
    func make(json: [String: Any]?) -> [CampaignResponseProtocol]
}

struct CampaignResponsesFactory: CampaignResponsesFactoryProtocol {
    
    private var campaignResponseFactory: CampaignResponseFactory
    
    init(singleCampaignResponseFactory: CampaignResponseFactory) {
        self.campaignResponseFactory = singleCampaignResponseFactory
    }
    
    func make(json: [String: Any]?) -> [CampaignResponseProtocol] {
        guard let jsonArray = json?["data"] as? [[String: Any]] else {
            return [ ]
        }
        let campaignsArr = jsonArray.compactMap {campaignResponseFactory.make(json: $0)}
        return campaignsArr
    }
}
