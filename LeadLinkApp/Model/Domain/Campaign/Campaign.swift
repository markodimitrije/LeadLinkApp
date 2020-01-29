//
//  File.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation

public struct Campaigns: Codable {
    var data: [Campaign]
}

public struct Campaign: Codable {
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
    
    var questions: [Question]
    var codes: [Code]?
    var application: Application
    var settings: Settings?
    var organization: Organization?
    
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
        self.color = campaign.color ?? "#ee9c00" // hard-coded
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
}


public struct CampaignResponses {
    var data: [CampaignResponseProtocol]
}
