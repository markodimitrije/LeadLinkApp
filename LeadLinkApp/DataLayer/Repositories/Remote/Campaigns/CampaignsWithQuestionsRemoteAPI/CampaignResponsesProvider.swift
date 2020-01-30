//
//  CampaignResponsesProvider.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct CampaignResponsesProvider {

    private var singleCampaignResponseFactory: CampaignResponseFactory
    
    init() {
        
        let applicationResponseFactory = ApplicationResponseFactory()
        let organizationResponseFactory = OrganizationResponseFactory()
        let optInResponseFactory = OptInResponseFactory()
        let disclaimerResponseFactory = DisclaimerResponseFactory()
        let settingsResponseFactory = SettingsResponseFactory(optInResponseFactory: optInResponseFactory, disclaimerResponseFactory: disclaimerResponseFactory)
        let questionsResponseFactory = QuestionResponseFactory()
        
        self.singleCampaignResponseFactory = CampaignResponseFactory(
            questionResponseFactory: questionsResponseFactory,
            applicationResponseFactory: applicationResponseFactory,
            settingsResponseFactory: settingsResponseFactory,
            organizationResponseFactory: organizationResponseFactory)
    }
    
    func make(data: Data) -> [CampaignResponseProtocol]? {
        
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return CampaignResponsesFactory(singleCampaignResponseFactory: self.singleCampaignResponseFactory)
            .make(json: json)
    }
}
