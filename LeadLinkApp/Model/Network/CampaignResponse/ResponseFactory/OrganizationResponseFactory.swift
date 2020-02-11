//
//  OrganizationResponseFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol OrganizationResponseFactoryProtocol {
    func make(json: [String: Any]?) -> OrganizationResponseProtocol?
}

struct OrganizationResponseFactory: OrganizationResponseFactoryProtocol {
    func make(json: [String: Any]?) -> OrganizationResponseProtocol? {
        return OrganizationResponse(json: json)
    }
}
