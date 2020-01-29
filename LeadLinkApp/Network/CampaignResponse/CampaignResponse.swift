//
//  CampaignResponse.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class CampaignResponse: CampaignResponseProtocol {
    
    var id: Int = -1
    var conference_id: Int = -1
    var name: String?
    var description: String?
    var user_id: Int?
    var organization_id: Int?
    var created_at: String? // (Date)
    var primary_color: String? // oprez - ne vidim iz response koji je ovo type
    var color: String? // oprez - ne vidim iz response koji je ovo type
    var logo: String? // url
    var imgData: Data? = nil
    var number_of_responses: Int?
    
    var applicationResponse: ApplicationResponseProtocol
    var settingsResponse: SettingsResponseProtocol?
    var organizationResponse: OrganizationResponseProtocol?
    
    var dateReadAt: Date?
    
    init?(json: [String: Any]?,
          appResponseFactory: ApplicationResponseFactoryProtocol,
          settingsResponseFactory: SettingsResponseFactoryProtocol,
          organizationResponseFactory: OrganizationResponseFactoryProtocol) {
        
        guard let json = json,
        let id = json["id"] as? Int,
        let conference_id = json["conference_id"] as? Int,
        let name = json["name"] as? String,
        let description = json["description"] as? String,
        let user_id = json["user_id"] as? Int,
        let organization_id = json["organization_id"] as? Int,
        let created_at = json["created_at"] as? String,
        let primary_color = json["primary_color"] as? String,
        let color = json["color"] as? String,
        let logo = json["logo"] as? String,
        let number_of_responses = json["number_of_responses"] as? Int else {
            return nil
        }
        
        guard let applicationJson = json["application"] as? [String: Any],
            let applicationResponse = appResponseFactory.make(json: applicationJson) else {
            return nil
        }
        
        self.id = id
        self.conference_id = conference_id
        self.name = name
        self.description = description
        self.user_id = user_id
        self.organization_id = organization_id
        self.created_at = created_at
        self.primary_color = primary_color
        self.color = color
        self.logo = logo
        self.number_of_responses = number_of_responses
        
        self.applicationResponse = applicationResponse
        self.settingsResponse = settingsResponseFactory.make(json: json["settings"] as? [String: Any])
        self.organizationResponse = organizationResponseFactory.make(json: json["organization"] as? [String: Any])
    }
    
}
