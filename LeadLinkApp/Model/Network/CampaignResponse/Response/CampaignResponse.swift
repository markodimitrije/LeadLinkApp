//
//  CampaignResponse.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol CampaignResponseProtocol {
    var id: Int {get set}
    var name: String? {get set}
    var description: String? {get set}
    var user_id: Int? {get set}
    var organization_id: Int? {get set}
    var conference_id: Int {get set}
    var created_at: String? {get set}
    var primary_color: String? {get set}
    var color: String? {get set}
    var logo: String? {get set}
    var number_of_responses: Int? {get set}
    var applicationResponse: ApplicationResponseProtocol {get set}
    var organizationResponse: OrganizationResponseProtocol? {get set}
    var settingsResponse: SettingsResponseProtocol? {get set}
    var questionResponse: [QuestionResponseProtocol] {get set}
}

public struct CampaignResponses {
    var data: [CampaignResponseProtocol]
}

class CampaignResponse: CampaignResponseProtocol {

    var id: Int = -1
    var conference_id: Int = -1
    var name: String?
    var description: String?
    var user_id: Int?
    var organization_id: Int?
    var created_at: String? // (Date)
    var primary_color: String?
    var color: String?
    var logo: String? // url
    var imgData: Data? = nil
    var number_of_responses: Int?
    
    var questionResponse: [QuestionResponseProtocol]
    var applicationResponse: ApplicationResponseProtocol
    var settingsResponse: SettingsResponseProtocol?
    var organizationResponse: OrganizationResponseProtocol?
    
    var dateReadAt: Date?
    
    init?(json: [String: Any]?,
          appResponseFactory: ApplicationResponseFactoryProtocol,
          settingsResponseFactory: SettingsResponseFactoryProtocol,
          organizationResponseFactory: OrganizationResponseFactoryProtocol,
          questionResponseFactory: QuestionResponseFactoryProtocol) {
        
        guard let json = json,
            let id = json["id"] as? Int,
            let applicationJson = json["application"] as? [String: Any],
            let applicationResponse = appResponseFactory.make(json: applicationJson) else {
                return nil
            }
            
        self.id = id
        self.conference_id = (json["conference_id"] as? Int) ?? 0
        self.name = json["name"] as? String
        self.description = json["description"] as? String
        self.user_id = json["user_id"] as? Int
        self.organization_id = json["organization_id"] as? Int
        self.created_at = json["created_at"] as? String
        self.primary_color = json["primary_color"] as? String
        self.color = json["color"] as? String
        self.logo = json["logo"] as? String
        self.number_of_responses = json["number_of_responses"] as? Int
        
        self.questionResponse = questionResponseFactory.make(json: json["questions"] as? [[String: Any]])
        self.applicationResponse = applicationResponse
        self.settingsResponse = settingsResponseFactory.make(json: json["settings"] as? [String: Any])
        self.organizationResponse = organizationResponseFactory.make(json: json["organization"] as? [String: Any])
    }
}
