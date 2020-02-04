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
    @objc dynamic var api_key: String = ""
    
    func updateWith(application: ApplicationProtocol) {
        self.id = application.id
        self.api_key = application.api_key
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
}
