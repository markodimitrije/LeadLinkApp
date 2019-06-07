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
    
    var myStringProperties: [String?] {
        //return ["first_name", "last_name", "email", "zip", "city", "address1"] // country_id
        return ["first_name", "last_name", "email", "zip", "city", "address1", "country_id"]
    }
    
    func value(optionKey: QuestionPersonalInfoKey) -> String {
        switch optionKey {
            case .email: return email ?? ""
            case .first_name: return first_name ?? ""
            case .last_name: return last_name ?? ""
            case .city: return city ?? ""
            case .zip: return zip ?? ""
            case .address1: return address1 ?? ""
            case .country_id:
                if country_id == nil {
                    return ""
                } else {
                    let countriesManager = CountriesManager()
                    return countriesManager.countries["\(country_id!)"] ?? ""
            }
        }
    }
    
}

public struct DelegatesStructure: Codable {
    var data = [Delegate]()
}

enum PersonalInfoKey: String {
    case first_name = "first_name"
    case last_name = "last_name"
    case email = "email"
    case country_id = "country_id"
    case city = "city"
    case zip = "zip"
    case address1 = "address1"
}

enum QuestionPersonalInfoKey: String {
    case first_name = "first_name"
    case last_name = "last_name"
    case email = "email"
    case country_id = "country"
    case city = "city"
    case zip = "zip"
    case address1 = "address1"
}

