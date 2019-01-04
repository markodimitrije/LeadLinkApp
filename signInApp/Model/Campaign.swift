//
//  File.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

public struct Campaigns: Codable {
    var data: [Campaign]
}

public struct Campaign: Codable {
    var id: Int
    var name: String
    var description: String
    var user_id: Int
    var conference_id: Int
    var organization_id: Int
    var created_at: String // (Date)
    var primary_color: String? // oprez - ne vidim iz response koji je ovo type
    var color: String? // oprez - ne vidim iz response koji je ovo type
    var logo: String? // url
    var settings: [String] // oprez - ne vidim iz response koji je ovo type
    
    init(realmCampaign campaign: RealmCampaign) {
        self.id = campaign.id
        self.name = campaign.name
        self.description = campaign.desc
        self.user_id = campaign.user_id
        self.conference_id = campaign.conference_id
        self.organization_id = campaign.organization_id
        self.created_at = campaign.created_at
        self.primary_color = campaign.primary_color
        self.color = campaign.color
        self.logo = campaign.logo
        self.settings = Array(campaign.settings)
    }
}
