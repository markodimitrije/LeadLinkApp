//
//  OrganizationResponse.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol OrganizationResponseProtocol {
    var id: Int {get set}
    var name: String {get set}
}

struct OrganizationResponse: OrganizationResponseProtocol {
    
    var id: Int
    var name: String
    
    init?(json: [String: Any]?) {
        guard let json = json,
            let id = json["id"] as? Int,
            let name = json["name"] as? String else {
                return nil
        }
        self.id = id
        self.name = name
    }
}
