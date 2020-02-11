//
//  OptInResponse.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol OptInResponseProtocol {
    var url: String { get }
    var text: String { get }
    var privacyPolicy: String { get }
}

struct OptInResponse: OptInResponseProtocol {
    
    var url: String
    var text: String
    var privacyPolicy: String
    
    init?(json: [String: Any]?) {
        guard let url = json?["url"] as? String,
            let text = json?["text"] as? String,
            let privacyPolicy = json?["privacyPolicy"] as? String else {
                return nil
        }
        self.url = url
        self.text = text
        self.privacyPolicy = privacyPolicy
    }
}
