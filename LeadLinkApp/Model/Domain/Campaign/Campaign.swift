//
//  File.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct Campaigns {
    var data: [CampaignProtocol]
}

protocol CampaignProtocol {
    var id: Int { get set }
    var conference_id: Int { get set }
    var name: String? { get set }
    var description: String? { get set }
    var user_id: Int? { get set }
    var organization_id: Int? { get set }
    var created_at: String? { get set }
    var primary_color: String? { get set }
    var color: String? { get set }
    var logo: String? { get set }
    var imgData: Data? { get set }
    var number_of_responses: Int? { get set }
    
    var questions: [QuestionProtocol] { get set }
    var codes: [Code]? { get set }
    var application: ApplicationProtocol { get set }
    var settings: SettingsProtocol? { get set }
    var organization: OrganizationProtocol? { get set }
    
    var dateReadAt: Date? { get set }
}

public struct Campaign: CampaignProtocol {
    var id: Int = -1
    var conference_id: Int = -1
    var name: String?
    var description: String?
    var user_id: Int?
    var organization_id: Int?
    var created_at: String?
    var primary_color: String?
    var color: String?
    var logo: String? // url
    var imgData: Data? = nil
    var number_of_responses: Int?
    
    var questions: [QuestionProtocol]
    var codes: [Code]?
    var application: ApplicationProtocol
    var settings: SettingsProtocol?
    var organization: OrganizationProtocol?
    
    var dateReadAt: Date?
    
    init(realmCampaign campaign: RealmCampaign) {
        self.id = campaign.id
        self.conference_id = campaign.conference_id
        self.name = campaign.name
        self.description = campaign.desc
        self.user_id = campaign.user_id
        self.organization_id = campaign.organization_id
        self.created_at = campaign.created_at
        self.primary_color = campaign.primary_color
        self.color = campaign.color ?? "#ee9c00"
        self.logo = campaign.logo
        self.imgData = campaign.imgData
        self.number_of_responses = campaign.number_of_responses
        
        self.questions = campaign.questions.toArray().map(Question.init)
        self.codes = campaign.codes.toArray().map(Code.init)
        
        self.application = Application(realmApplication: campaign.application)
        
        self.settings = Settings(realmSettings: campaign.settings)
        
        self.organization = Organization(realmOrganization: campaign.organization)
        
        self.dateReadAt = campaign.dateReadAt
    }
    
    init(campaignResponse: CampaignResponseProtocol) {
        
        self.application = Application(applicationResponse: campaignResponse.applicationResponse)
        self.organization = Organization(organizationResponse: campaignResponse.organizationResponse)
        self.settings = Settings(settingsResponse: campaignResponse.settingsResponse)
        let questions = campaignResponse.questionResponse.map(Question.init)
        self.questions = questions
        
        self.id = campaignResponse.id
        self.conference_id = campaignResponse.conference_id
        self.name = campaignResponse.name
        self.description = campaignResponse.description
        self.user_id = campaignResponse.user_id
        self.organization_id = campaignResponse.organization_id
        self.created_at = campaignResponse.created_at // (Date)
        self.primary_color = campaignResponse.primary_color
        self.color = campaignResponse.color
        self.logo = campaignResponse.logo
        self.imgData = nil
        self.number_of_responses = campaignResponse.number_of_responses
    }
    
}
