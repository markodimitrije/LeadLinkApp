//
//  RealmJson.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 10/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Realm
import RealmSwift

// cuva u sebi sve originale json zahteva (koristim za versioning)

class RealmJson: Object {
    
    @objc dynamic var name: String = "" // web request, endpoint ili slicno
    @objc dynamic var value: String = "" // content
    
    public func update(name: String, value: String) {
        self.name = name
        self.value = value
    }

    override static func primaryKey() -> String? {
        return "name"
    }
    
}

