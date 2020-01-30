//
//  ResponseFactoryProtocols.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol CampaignResponseFactoryProtocol {
    func make(json: [String: Any]?) -> CampaignResponseProtocol?
}

// campaign parts factory protocols

protocol SettingsResponseFactoryProtocol {
    func make(json: [String: Any]?) -> SettingsResponseProtocol?
}


protocol QuestionResponseFactoryProtocol {
    func make(json: [[String: Any]]?) -> [QuestionResponseProtocol]
}
protocol ApplicationResponseFactoryProtocol {
    func make(json: [String: Any]?) -> ApplicationResponseProtocol?
}
protocol OrganizationResponseFactoryProtocol {
    func make(json: [String: Any]?) -> OrganizationResponseProtocol?
}

