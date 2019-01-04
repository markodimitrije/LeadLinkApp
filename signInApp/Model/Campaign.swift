//
//  File.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

public struct Campaigns: Codable {
    var data: [Campaign]
}

public struct Campaign: Codable {
    var id: String
    var name: String
    var description: String
    var user_id: Int
    var conference_id: Int
    var organization_id: Int
    var created_at: String // (Date)
    var primary_color: String? // oprez - ne vidim iz response koji je ovo type
    var color: String? // oprez - ne vidim iz response koji je ovo type
    var logo: String // url
    var settings: [String] // oprez - ne vidim iz response koji je ovo type
}
