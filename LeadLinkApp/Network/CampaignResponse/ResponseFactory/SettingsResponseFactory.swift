//
//  SettingsResponseFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct SettingsResponseFactory: SettingsResponseFactoryProtocol {
    
    private var optInResponseFactory: OptInResponseFactoryProtocol
    private var disclaimerResponseFactory: DisclaimerResponseFactoryProtocol
    
    init(optInResponseFactory: OptInResponseFactoryProtocol,
         disclaimerResponseFactory: DisclaimerResponseFactoryProtocol) {
        self.optInResponseFactory = optInResponseFactory
        self.disclaimerResponseFactory = disclaimerResponseFactory
    }
    
    func make(json: [String: Any]?) -> SettingsResponseProtocol? {
        let settingsResponse = SettingsResponse(json: json,
                                                optInResponseFactory: self.optInResponseFactory,
                                                disclaimerResponseFactory: self.disclaimerResponseFactory)
        return settingsResponse
    }
}
