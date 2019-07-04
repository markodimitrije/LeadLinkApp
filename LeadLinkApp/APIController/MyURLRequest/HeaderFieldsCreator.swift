//
//  HeaderFieldsCreator.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 27/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class HeaderFieldsCreator {
    var allHeaderFields = [String: String]()
    
    init(apiKey: String? = nil,
         authorization: String? = nil,
         deviceUdid: String? = nil,
         contentType: String? = nil) {
        
        if let apiKey = apiKey {
            allHeaderFields["Api-Key"] = apiKey
        }
        if let authorization = authorization {
            allHeaderFields["Authorization"] = authorization
        }
        if let deviceUdid = deviceUdid {
            allHeaderFields["device-id"] = deviceUdid
        }
        if let contentType = contentType {
            allHeaderFields["Content-Type"] = contentType
        }
    }
}

class CampaignDelegateHeaderFieldsCreator: HeaderFieldsCreator {
    init() {
        super.init(apiKey: confApiKeyState.apiKey,
                   authorization: confApiKeyState.authentication,
                   deviceUdid: UIDevice.current.identifierForVendor?.uuidString,
                   contentType: "application/json")
    }
}

class AnswersHeaderFieldsCreator: HeaderFieldsCreator {
    init() {
        super.init(apiKey: confApiKeyState.apiKey,
                   authorization: confApiKeyState.authentication,
                   contentType: "application/json")
    }
}

class CampaignsWithQuestionsHeaderFieldsCreator: HeaderFieldsCreator {
    init() {
        super.init(authorization: confApiKeyState.authentication,
                   contentType: "application/json")
    }
}
