//
//  Organization.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 10/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol OrganizationProtocol {
    var id: Int { get set }
    var name: String { get set }
}

public struct Organization: OrganizationProtocol {
    var id: Int
    var name: String
    
    init(realmOrganization organization: RealmOrganization?) {
        self.id = organization?.id ?? 0
        self.name = organization?.name ?? "unknown"
    }
    
    init?(organizationResponse: OrganizationResponseProtocol?) {
        guard let organizationResponse = organizationResponse else {
            return nil
        }
        self.id = organizationResponse.id
        self.name = organizationResponse.name
    }
    
}
