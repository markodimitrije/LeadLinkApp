//
//  CampaignResponseFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct CampaignResponseFactory: CampaignResponseFactoryProtocol {
    
    private var applicationResponseFactory: ApplicationResponseFactoryProtocol
    private var settingsResponseFactory: SettingsResponseFactoryProtocol
    private var organizationResponseFactory: OrganizationResponseFactoryProtocol
    
    init(applicationResponseFactory: ApplicationResponseFactoryProtocol,
         settingsResponseFactory: SettingsResponseFactoryProtocol,
         organizationResponseFactory: OrganizationResponseFactoryProtocol) {
        self.applicationResponseFactory = applicationResponseFactory
        self.settingsResponseFactory = settingsResponseFactory
        self.organizationResponseFactory = organizationResponseFactory
    }
    
    func make(json: [String: Any]?) -> CampaignResponse? {
        guard let json = json else { return nil }
        let applicationResponse = applicationResponseFactory.make(json: json["application"] as? [String: Any])
        let settingsResponse = settingsResponseFactory.make(json: json["settings"] as? [String: Any])
        let organizationResponse = organizationResponseFactory.make(json: json["organization"]  as? [String: Any])
        
        let campaignResponse = CampaignResponse(json: json,
                                                appResponseFactory: applicationResponseFactory,
                                                settingsResponseFactory: settingsResponseFactory,
                                                organizationResponseFactory: organizationResponseFactory)
        campaignResponse?.applicationResponse = applicationResponse
        campaignResponse?.settingsResponse = settingsResponse
        campaignResponse?.organizationResponse = organizationResponse
        return campaignResponse
    }
}

