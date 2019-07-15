//
//  ScanditAllowable.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 15/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol ScanditAllowable {
    func canUseScandit() -> Bool
}

class ScanditAllownessValidator: ScanditAllowable {
    
    var campaign: Campaign?
    
    init(campaign: Campaign?) {
        self.campaign = campaign
    }
    
    func canUseScandit() -> Bool {
        return true // hard-coded for test
        guard let campaign = self.campaign else {return false}
        return campaign.use_scandit_scanner ?? false
    }
}
