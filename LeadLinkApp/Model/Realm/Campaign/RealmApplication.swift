//
//  RealmApplication.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 04/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RealmSwift

public class RealmApplication: Object {
    
    @objc dynamic var id: Int = 0
//    @objc dynamic var name: String = ""
//    @objc dynamic var type: String = ""
//    var portal_id: Int? = nil
//    var conference_id: Int? = nil
    @objc dynamic var api_key: String = ""
    
//    @objc dynamic var setting: RealmSetting? = RealmSetting.init()
    
    func updateWith(application: Application) {
        self.id = application.id
//        self.type = application.type ?? ""
//        self.name = application.name ?? ""
//        self.portal_id = application.portal_id
//        self.conference_id = application.conference_id
        self.api_key = application.api_key
        
//        self.setting?.updateWith(setting: application.settings)
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
}
