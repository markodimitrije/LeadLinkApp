//
//  ScanditAllownessValidator.swift
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
    
    var campaign: CampaignProtocol?
    
    init(campaign: CampaignProtocol?) {
        self.campaign = campaign
    }
    
    func canUseScandit() -> Bool {
//        return false // hard-coded for test
        guard let campaign = self.campaign else {
            return false
        }
        return campaign.settings?.use_scandit_scanner ?? false
    }
}
