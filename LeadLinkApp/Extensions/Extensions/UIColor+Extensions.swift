//
//  UIColor+Extensions.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

extension UIColor {
    static let barcodeTxtGray = UIColor.init(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0)
    static let fieldBorderGray = UIColor.init(red: 159/255, green: 159/255, blue: 159/255, alpha: 1.0)
    static let barcodeBackground = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
    //static let disclaimerBlue = UIColor.init(red: 57/255, green: 89/255, blue: 121/255, alpha: 1.0)
    static let disclaimerBlue = UIColor.init(red: 106/255, green: 130/255, blue: 155/255, alpha: 1.0)
    static var leadLinkColor: UIColor {
        guard let campaignId = selectedCampaignId else {
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
        Scanner(string: hex).scanHexInt32(&int)
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
