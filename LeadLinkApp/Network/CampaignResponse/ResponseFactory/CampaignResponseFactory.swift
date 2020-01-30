//
//  CampaignResponseFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct CampaignResponseFactory: CampaignResponseFactoryProtocol {
    
    private var questionResponseFactory: QuestionResponseFactoryProtocol
    private var applicationResponseFactory: ApplicationResponseFactoryProtocol
    private var settingsResponseFactory: SettingsResponseFactoryProtocol
    private var organizationResponseFactory: OrganizationResponseFactoryProtocol
    
    init(questionResponseFactory: QuestionResponseFactoryProtocol,
         applicationResponseFactory: ApplicationResponseFactoryProtocol,
         settingsResponseFactory: SettingsResponseFactoryProtocol,
         organizationResponseFactory: OrganizationResponseFactoryProtocol) {
        self.questionResponseFactory = questionResponseFactory
        self.applicationResponseFactory = applicationResponseFactory
        self.settingsResponseFactory = settingsResponseFactory
        self.organizationResponseFactory = organizationResponseFactory
    }
    
    func make(json: [String: Any]?) -> CampaignResponseProtocol? {
        guard let json = json,
            let applicationResponse = applicationResponseFactory.make(json: json["application"] as? [String: Any]) else {
                
                return nil
        }
        
        let settingsResponse = settingsResponseFactory.make(json: json["settings"] as? [String: Any])
        let organizationResponse = organizationResponseFactory.make(json: json["organization"]  as? [String: Any])
        let questionResponse = questionResponseFactory.make(json: json["questions"] as? [[String: Any]])
        
        let campaignResponse = CampaignResponse(json: json,
                                                appResponseFactory: applicationResponseFactory,
                                                settingsResponseFactory: settingsResponseFactory,
                                                organizationResponseFactory: organizationResponseFactory,
                                                questionResponseFactory: questionResponseFactory)
        
//        campaignResponse?.applicationResponse = applicationResponse
//        campaignResponse?.settingsResponse = settingsResponse
//        campaignResponse?.organizationResponse = organizationResponse
//        campaignResponse?.questionResponse = questionResponse
        
        return campaignResponse
    }
}

