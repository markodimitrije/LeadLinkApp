//
//  RealmOrganization.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 10/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RealmSwift

class RealmOrganization: Object {

    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    
    public func update(with organization: Organization) {
        
        self.id = organization.id
        self.name = organization.name
        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
