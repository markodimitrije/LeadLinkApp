//
//  Organization.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 10/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

public struct Organization: Codable {
    var id: Int
    var name: String
    
    init(realmOrganization organization: RealmOrganization?) {
        self.id = organization?.id ?? 0
        self.name = organization?.name ?? "unknown"
    }
    
}
