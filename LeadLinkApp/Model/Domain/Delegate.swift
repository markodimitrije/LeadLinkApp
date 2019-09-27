//
//  Delegate.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 05/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

public struct DelegatesStructure: Codable {
    var data = [Delegate]()
}

public struct Delegate: Codable {

    var id: Int
    var consentGiven: Bool?
    var first_name: String?
    var last_name: String?
    var email: String?
    var zip: String?
    var city: String?
    var country_id: Int?
    var address1: String?
    
    var myStringProperties: [String?] {
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

enum QuestionPersonalInfoKey: String {
    case first_name = "first_name"
    case last_name = "last_name"
    case email = "email"
    case country_id = "country"
    case city = "city"
    case zip = "zip"
    case address1 = "address1"
}

