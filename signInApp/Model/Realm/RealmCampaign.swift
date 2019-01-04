//
//  RealmCampaign.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Realm
import RealmSwift

//public struct Campaigns: Codable {
//    var data: [Campaign]
//}

class RealmCampaign: Object {
    //@objc dynamic var id = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var user_id: Int = 0
    @objc dynamic var conference_id: Int = 0
    @objc dynamic var organization_id: Int = 0
    @objc dynamic var created_at: String = ""// (Date)
    @objc dynamic var primary_color: String? // oprez - ne vidim iz response koji je ovo types
    @objc dynamic var color: String? // oprez - ne vidim iz response koji je ovo type
    @objc dynamic var logo: String? = "" // url
    var settings = List<String>() // oprez - ne vidim iz response koji je ovo type

    public func update(with campaign: Campaign) {
        self.id = campaign.id
        self.name = campaign.name
        self.desc = campaign.description
        self.user_id = campaign.user_id
        self.conference_id = campaign.conference_id
        self.organization_id = campaign.organization_id
        self.created_at = campaign.created_at
        self.primary_color = campaign.primary_color
        self.color = campaign.color
        self.logo = campaign.logo
        let list = List<String>.init(); list.append(objectsIn: settings)
        self.settings = list
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
//    override static func ignoredProperties() -> [String] { // sta nije bitno za Scaner app?
//        return ["primary_color"]//, "floor", "imported_id"]
//    }
    
}
