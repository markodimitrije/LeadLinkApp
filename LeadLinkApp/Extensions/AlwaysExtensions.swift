//
//  Extensions.swift
//  tryToAppendDataToFile
//
//  Created by Marko Dimitrijevic on 12/09/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

extension FileManager {
    static var docDirUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

extension Date {
    static var now: Date {
        return Date.init(timeIntervalSinceNow: 0)
    }
}

// ovo koristi svuda !!!

extension Data {
    var toString: String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
}

extension String {
    var toData: Data? {
        return self.data(using: String.Encoding.utf8)
    }
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

extension DateFormatter {
    
    convenience init(format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
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

extension CGRect {
    var center: CGPoint {
        return CGPoint.init(x: self.origin.x - self.size.width/2, y: self.origin.y - self.size.height/2)
    }
    init(center: CGPoint, size: CGSize) {
        let orig = CGPoint.init(x: center.x - size.width/2, y: center.y - size.height/2)
        let rect = CGRect.init(origin: orig, size: size)
        self = rect
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UITextView {
    
    func hyperLink(originalText: String, hyperLinkFirst: String, urlStringFirst: String,
                   hyperLinkSecond: String, urlStringSecond: String) {
        
        let style = NSMutableParagraphStyle()
        style.alignment = .justified
        
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let linkRangeFirst = attributedOriginalText.mutableString.range(of: hyperLinkFirst)
        let linkRangeSecond = attributedOriginalText.mutableString.range(of: hyperLinkSecond)
        let fullRange = NSMakeRange(0, attributedOriginalText.length)
        
        attributedOriginalText.addAttribute(.link, value: urlStringFirst, range: linkRangeFirst)
        attributedOriginalText.addAttribute(.link, value: urlStringSecond, range: linkRangeSecond)
        
        attributedOriginalText.addAttribute(.paragraphStyle, value: style, range: fullRange)
        attributedOriginalText.addAttribute(.foregroundColor, value: UIColor.black, range: fullRange)
        attributedOriginalText.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: fullRange)
        
        self.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.blue,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        
        self.attributedText = attributedOriginalText
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
