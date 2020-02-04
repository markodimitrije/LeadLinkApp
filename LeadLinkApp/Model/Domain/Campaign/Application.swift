//
//  Application.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 04/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol ApplicationProtocol {
    var id: Int { get set }
    var api_key: String { get set }
}

public struct Application: Codable, ApplicationProtocol {
    
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
