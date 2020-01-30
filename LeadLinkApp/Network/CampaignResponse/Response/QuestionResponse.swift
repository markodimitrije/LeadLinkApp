//
//  QuestionResponse.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol QuestionResponseProtocol {
    var id: Int { get set}
    var campaign_id: Int { get set}
    var title: String { get set}
    var type: String { get set}
    var group: String { get set}
    var required: Bool { get set}
    var description: String? { get set}
    var order: Int { get set}
    var settings: QuestionSettingsResponseProtocol { get set}
}

struct QuestionResponse: QuestionResponseProtocol {
    var id: Int
    var campaign_id: Int
    var title: String
    var type: String
    var group: String
    var required: Bool
    var description: String?
    var order: Int
    var settings: QuestionSettingsResponseProtocol
    
    init?(json: [String: Any]?) {
        guard let json = json,
            let id = json["id"] as? Int,
            let campaign_id = json["campaign_id"] as? Int,
            let title = json["title"] as? String,
            let type = json["type"] as? String,
            let group = json["group"] as? String,
            let required = json["required"] as? Bool,
            let order = json["order"] as? Int,
            let settings = QuestionSettingsResponse(json: json["settings"] as? [String: Any]) else {
                return nil
        }
        self.id = id
        self.campaign_id = campaign_id
        self.title = title
        self.type = type
        self.group = group
        self.required = required
        self.order = order
        self.settings = settings
    }
}


