//
//  OptInResponseFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol OptInResponseFactoryProtocol {
    func make(json: [String: Any]?) -> OptInResponseProtocol?
}

struct OptInResponseFactory: OptInResponseFactoryProtocol {
    func make(json: [String: Any]?) -> OptInResponseProtocol? {
        return OptInResponse(json: json)
    }
}
