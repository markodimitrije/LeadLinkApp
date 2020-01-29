//
//  ApplicationResponseFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct ApplicationResponseFactory: ApplicationResponseFactoryProtocol {
    func make(json: [String: Any]?) -> ApplicationResponseProtocol? {
        return nil
    }
}
