//
//  ApplicationResponse.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol ApplicationResponseProtocol {
    var id: Int {get set}
    var api_key: String {get set}
}

struct ApplicationResponse: ApplicationResponseProtocol {
    var id: Int
    var name: String
    var portal_id: Int
    var conference_id: Int
    var api_key: String
    var type: String
    
    init?(json: [String: Any]?) {
        guard let json = json,
        let id = json["id"] as? Int,
        let name = json["name"] as? String,
        let portal_id = json["portal_id"] as? Int,
        let conference_id = json["conference_id"] as? Int,
        let api_key = json["api_key"] as? String,
        let type = json["type"] as? String else {
            return nil
        }
        self.id = id
        self.name = name
        self.portal_id = portal_id
        self.conference_id = conference_id
        self.api_key = api_key
        self.type = type
    }
}
