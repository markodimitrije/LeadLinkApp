//
//  CampaignResponseProtocol.swift
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
}
protocol QuestionsResponseProtocol {}
protocol CodesProcol {}
protocol ApplicationResponseProtocol {
    var id: Int {get set}
    var api_key: String {get set}
}

protocol OrganizationResponseProtocol {
    var id: Int {get set}
    var name: String {get set}
}
