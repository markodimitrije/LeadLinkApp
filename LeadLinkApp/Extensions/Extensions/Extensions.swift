//
//  Extensions.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 10/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import Realm

// MARK:- Always extensions // ok to be in Pods

extension UIView {
    static func closestParentObject<T: UIView, U: UIView>(for object: T, ofType type: U.Type) -> U? {
        guard let parent = object.superview else {
            return nil
        }
        if let parent = parent as? U {
            return parent
        } else {
            return closestParentObject(for: parent, ofType: type)
        }
    }
}

extension UIView {
    func removeAllSubviews() {
        _ = subviews.map {$0.removeFromSuperview()}
    }
    // increse or decrease just
    func resizeHeight(by amount: CGFloat) {
        let actualFrame = self.frame
        let new = CGRect.init(origin: actualFrame.origin, size: CGSize.init(width: actualFrame.width, height: actualFrame.height + amount))
        self.frame = new
    }
    func resizeWidth(by amount: CGFloat) {
        let actualFrame = self.frame
        let new = CGRect.init(origin: actualFrame.origin, size: CGSize.init(width: actualFrame.width + amount, height: actualFrame.height))
        self.frame = new
    }
    func resize(byWidth width: CGFloat, byHeight height: CGFloat) {
        self.resizeWidth(by: width)
        self.resizeHeight(by: height)
    }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}

extension UIColor {
    static let barcodeTxtGray = UIColor.init(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0)
    static let fieldBorderGray = UIColor.init(red: 159/255, green: 159/255, blue: 159/255, alpha: 1.0)
    static let barcodeBackground = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
    static let disclaimerBlue = UIColor.init(red: 57/255, green: 89/255, blue: 121/255, alpha: 1.0)
    static var leadLinkColor: UIColor {
        guard let campaignId = UserDefaults.standard.value(forKey: "campaignId") as? Int else {
            return UIColor(hexString: "#672edf")
        }
        guard let colorName = factory.sharedCampaignsRepository.dataStore.readCampaign(id: campaignId).value?.color else {
            return UIColor(hexString: "#672edf")
        }
        return UIColor(hexString: colorName)
    }
    
    static let notSyncedWebReports = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        //Scanner(string: hex).scanHexInt32(&int)// hard-coded, odakle ovo ovde ???
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false // VRH !!
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIView {
    func locateClosestChild<T: UITextInput>(ofType objectType: T.Type) -> T? {
        
//        if type(of: self) is UITextField || type(of: self) is UITextView {
//            return self as! T
//        }
        
        if self.subviews.count == 0 {
            return nil
        } else {
            let matchedTypeSubviews = self.subviews.compactMap { subview -> T? in
                if type(of: subview) is T.Type {
                    return subview as! T
                } else {
                    return subview.locateClosestChild(ofType: objectType)
                }
            }
            return matchedTypeSubviews.first
        }
    }
}

extension UITableView {
    
    func isCellBelowHalfOfTheScreen(cell: UITableViewCell) -> Bool {
        let contentOffsetVertical = self.contentOffset.y
        let distFromCellToTableCenter = cell.frame.origin.y - contentOffsetVertical
        return distFromCellToTableCenter > self.frame.midY
    }
    
    func getFirstCellBelow(cell: UITableViewCell) -> UITableViewCell? {
        
        var countOfCellsInSection = 0
        guard let actualIndexPath = self.indexPath(for: cell),
            let sectionIndex = self.indexPath(for: cell)?.section else {
                fatalError()
        }
                
        countOfCellsInSection = self.numberOfRows(inSection: sectionIndex)
        
        var newIp: IndexPath!
        if actualIndexPath.row + 1 < countOfCellsInSection {
            newIp = IndexPath(row: actualIndexPath.row + 1, section: actualIndexPath.section)
        } else {
            newIp = IndexPath(row: 0, section: actualIndexPath.section + 1)
        }
        return self.cellForRow(at: newIp)
    }
    
    func getFirstCellAbove(cell: UITableViewCell) -> UITableViewCell? {
        
        var countOfCellsInSection = 0
        guard let actualIndexPath = self.indexPath(for: cell),
            let sectionIndex = self.indexPath(for: cell)?.section else {
                fatalError()
        }
        
        countOfCellsInSection = self.numberOfRows(inSection: sectionIndex)
        
        var newIp: IndexPath!
        if isActualIndexSafe(actualIndexPath: actualIndexPath, countOfCellsInSection: countOfCellsInSection) {
            newIp = IndexPath(row: actualIndexPath.row - 1, section: actualIndexPath.section)
        } else {
            let lastIndexInPreviousSection = self.numberOfRows(inSection: sectionIndex - 1) - 1
            newIp = IndexPath(row: lastIndexInPreviousSection, section: actualIndexPath.section - 1)
        }
        return self.cellForRow(at: newIp)
    }
    
    private func isActualIndexSafe(actualIndexPath: IndexPath, countOfCellsInSection: Int) -> Bool {
        return actualIndexPath.row + 1 <= countOfCellsInSection && actualIndexPath.row - 1 >= 0
    }
}

extension UserDefaults {
    static let keyResourcesDownloaded = "resourcesDownloaded"
    
    static let keyConferenceApiKey = "keyConferenceApiKey"
    static let keyConferenceId = "keyConferenceId"
    static let keyConferenceAuth = "keyConferenceAuth"
}

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

// Date to String

extension Date {
    var defaultDateFormat: String {
        return "yyyy-MM-dd HH:mm:ss"
    }
}

// String to Date

extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
        
    }
}
