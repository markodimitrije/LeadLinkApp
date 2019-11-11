//
//  String+Extensions.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

extension String {
    var questionPersonalInfoKey: QuestionPersonalInfoKey? {
        switch self {
            case "email": return .email
            case "first_name": return .first_name
            case "last_name": return .last_name
            case "city": return .city
            case "zip": return .zip
            case "address1": return .address1
            case "country_id": return .country_id
            
        default:
            print("questionPersonalInfoKey = nil !!!!")
            return nil
        }
    }
}

extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
        
    }
}
