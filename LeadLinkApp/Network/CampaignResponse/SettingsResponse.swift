//
//  SettingsResponse.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct SettingsResponse: SettingsResponseProtocol {
    
    let use_scandit_scanner: Bool
    let showEmail: Bool
    let optInResponse: OptInResponseProtocol?
    let disclaimerResponse: DisclaimerResponseProtocol?
    
    init?(json: [String: Any]?,
          optInResponseFactory: OptInResponseFactoryProtocol,
          disclaimerResponseFactory: DisclaimerResponseFactoryProtocol) {
        guard let json = json,
        let use_scandit_scanner = json["use_scandit_scanner"] as? Bool,
        let showEmail = json["showEmail"] as? Bool else {
            return nil
        }
        self.use_scandit_scanner = use_scandit_scanner
        self.showEmail = showEmail
        self.optInResponse = optInResponseFactory.make(json: json["optIn"] as? [String: String])
        self.disclaimerResponse = disclaimerResponseFactory.make(json: json["disclaimer"] as? [String: String])
    }
}
