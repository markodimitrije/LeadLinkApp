//
//  CampaignResponseFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol CampaignResponseFactoryProtocol {
    func make(json: [String: Any]?) -> CampaignResponseProtocol?
}

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
        
        guard let json = json else {
            return nil
        }
        let campaignResponse = CampaignResponse(json: json,
                                                appResponseFactory: applicationResponseFactory,
                                                settingsResponseFactory: settingsResponseFactory,
                                                organizationResponseFactory: organizationResponseFactory,
                                                questionResponseFactory: questionResponseFactory)
        return campaignResponse
    }
}

