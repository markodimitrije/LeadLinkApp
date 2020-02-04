//
//  File.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 06/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import Realm

class ConferenceApiKeyState: ConfIdApiKeyAuthSupplying {
    
    private var authToken = ""
    private var selectedCampaign: CampaignProtocol!
    
    var conferenceId: Int? {
        get {
            return selectedCampaign.conference_id
        }
    }
    var apiKey: String? {
        get {
            return selectedCampaign.application.api_key
        }
    }
    var authentication: String? {
        get {
            return authToken
        }
    }
    
    init(authToken: String, selectedCampaign: CampaignProtocol? = nil) {
        self.authToken = authToken
        self.selectedCampaign = selectedCampaign
    }
    
    init() {
        
        self.authToken = UserDefaults.standard.value(forKey: UserDefaults.keyConferenceAuth) as? String ?? ""
        
        if let campaignId = UserDefaults.standard.value(forKey: UserDefaults.keyConferenceId) as? Int {
            let sharedCampaignsRepository = factory.sharedCampaignsRepository
            sharedCampaignsRepository.dataStore.readCampaign(id: campaignId)
                .done { campaign in
                    self.selectedCampaign = campaign
            }
        }
    }
    
    // API:
    func updateWith(selectedCampaign campaign: CampaignProtocol) {
        self.selectedCampaign = campaign
    }
    
}
