//
//  ShowDisclaimerValidator.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 17/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

protocol ShowDisclaimerValidatorProtocol {
    func shouldShowDisclaimer(disclaimerAlreadyOnScreen: Bool, delegate: Delegate?) -> Bool
}

struct ShowDisclaimerValidator: ShowDisclaimerValidatorProtocol {
    var campaign: CampaignProtocol?
    init(campaign: CampaignProtocol?) {
        self.campaign = campaign
    }
    func shouldShowDisclaimer(disclaimerAlreadyOnScreen: Bool, delegate: Delegate?) -> Bool {
        if !disclaimerAlreadyOnScreen {
            if !campaignHasSettingsWithDisclaimer() {
                return false
            }
            if !delegateExistsInRemoteDatabase(delegate: delegate) {
                return false
            }
            return shouldAskForConsent(delegate: delegate)
        }
        return false
    }
    
    private func shouldAskForConsent(delegate: Delegate?) -> Bool {
        guard let delegate = delegate else {
            return false
        }
        guard let consentGiven = delegate.consentGiven else {
            return true
        }
        return !consentGiven
    }
    
    private func delegateExistsInRemoteDatabase(delegate: Delegate?) -> Bool {
        return delegate != nil
    }
    
    private func campaignHasSettingsWithDisclaimer() -> Bool {
        return
            campaign?.settings?.disclaimer?.url != nil && campaign?.settings?.disclaimer?.text != nil
    }
}
