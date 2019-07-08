//
//  Application.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 04/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

public struct Application: Codable {
    var id: Int
//    var name: String?
//    var type: String?
//    var portal_id: Int?
//    var conference_id: Int?
    var api_key: String
//    var settings: Setting
    
    init(realmApplication: RealmApplication) {
        self.id = realmApplication.id
//        self.name = realmApplication.name
//        self.type = realmApplication.type
//        self.conference_id = realmApplication.conference_id
//        self.portal_id = realmApplication.portal_id
        
        self.api_key = realmApplication.api_key
//        self.settings = Setting.init(realmSetting: realmApplication.setting!)
    }
}
