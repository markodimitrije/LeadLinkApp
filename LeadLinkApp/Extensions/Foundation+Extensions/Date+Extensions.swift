//
//  Date+Extensions.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

extension Date {
    var defaultDateFormat: String {
        return "yyyy-MM-dd HH:mm:ss"
    }
}

extension Date {
    static var now: Date {
        return Date.init(timeIntervalSinceNow: 0)
    }
}

extension Date { // (*)
    
    func toString(format:String) -> String? {
        return DateFormatter(format: format).string(from: self)
    }
    
    static var defaultFormatString = "yyyy-MM-dd HH:mm:ss"
    static var codeReportShortFormatString = "dd-MM, HH:mm"
}

extension Date { // (*)
    
    static func parse(_ string: String, format: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        //        print("string = \(string)")
        let dateFormatter = DateFormatter()
        
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        //        print("parsedDate from string = \(dateFormatter.date(from: string)!)")
        return dateFormatter.date(from: string)!
    }
    
    static func parseIntoTime(_ string: String, outputWithSeconds: Bool, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        
        let date = parse(string, format: format)
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .none
        
        formatter.timeStyle = outputWithSeconds ? .medium : .short
        
        return formatter.string(from: date).components(separatedBy: " ").first ?? ""
        
    }
    
    static func parseIntoDateOnly(_ string: String, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        
        let date = parse(string, format: format)
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        
        formatter.timeStyle = .none
        
        return formatter.string(from: date)//.components(separatedBy: " ").first ?? ""
        
    }
    
}
