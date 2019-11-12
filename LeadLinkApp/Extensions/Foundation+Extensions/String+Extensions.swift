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

extension String {
    var toData: Data? {
        return self.data(using: String.Encoding.utf8)
    }
}

extension String {
    
    func toDate(format: String) -> Date? {
        return DateFormatter(format: format).date(from: self)
    }
    
    func toDateString(inputFormat: String, outputFormat:String) -> String? {
        if let date = toDate(format: inputFormat) {
            return DateFormatter(format: outputFormat).string(from: date)
        }
        return nil
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
