//
//  ApplicationResponseFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol ApplicationResponseFactoryProtocol {
    func make(json: [String: Any]?) -> ApplicationResponseProtocol?
}

struct ApplicationResponseFactory: ApplicationResponseFactoryProtocol {
    func make(json: [String: Any]?) -> ApplicationResponseProtocol? {
        return ApplicationResponse(json: json)
    }
}
