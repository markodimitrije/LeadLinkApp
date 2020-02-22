//
//  File.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 04/10/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol DelegateEmailScrambling {
    func shouldShowEmail() -> Bool
}

class DelegateEmailScrambler: DelegateEmailScrambling {
    private var campaign: CampaignProtocol
    init(campaign: CampaignProtocol) {
        self.campaign = campaign
    }
    func shouldShowEmail() -> Bool {
        return campaign.settings?.showEmail ?? true//false// ?? true
    }
}
