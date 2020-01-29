//
//  Application.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 04/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

public struct Application: Codable {
    
    var id: Int
    var api_key: String
    
    init(realmApplication: RealmApplication) {
        self.id = realmApplication.id
        self.api_key = realmApplication.api_key
    }
    
    init(applicationResponse: ApplicationResponseProtocol) {
        self.id = applicationResponse.id
        self.api_key = applicationResponse.api_key
    }
    
}
