//
//  Delegate.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 05/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

/*
 {
 "id": 153330,
 "email": "christina.ynares@dciinc.org",
 "code": "000024",
 "title": "Dr.",
 "name": null,
 "first_name": "CHRISTINA  ",
 "last_name": "YNARES",
 "country_id": 239,
 "user_id": null,
 "imported_id": "d2",
 "website": "2",
 "city": "Nashville TN",
 "zip": "",
 "address1": ""
 }
 */

import Foundation

public struct Delegate: Codable {
    //first_name, last_name, email, zip, city, country_id, address1
    var id: Int
    var first_name: String?
    var last_name: String?
    var email: String?
    var zip: String?
    var city: String?
    var country_id: Int?
    var address1: String?
    
//    init?(realmAnswer: RealmDelegate?) {
//        guard let realmAnswer = realmAnswer else {
//            return nil
//        }
//        self.id = realmAnswer.id
//        self.questionId = realmAnswer.questionId
//        self.code = realmAnswer.code
//        self.content = Array(realmAnswer.content)
//    }
}

public struct DelegatesStructure: Codable {
    var data = [Delegate]()
}
