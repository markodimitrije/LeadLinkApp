//
//  RealmFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/02/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import RealmSwift

class RealmFactory {
    static func make() -> Realm {
        do {
            let realm = try! Realm.init() // should refactor to display error if realm cant be made
            return realm
        }
    }
}
