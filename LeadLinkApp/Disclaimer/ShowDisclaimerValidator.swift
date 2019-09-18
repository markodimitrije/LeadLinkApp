//
//  ShowDisclaimerValidator.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 17/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

struct ShowDisclaimerValidator {
    var code: String
    var delegate: Delegate?
    var campaign: Campaign?
    init(code: String, delegate: Delegate?, campaign: Campaign?) {
        self.code = code
        self.delegate = delegate
        self.campaign = campaign
    }
    func shouldShowDisclaimer(disclaimerAlreadyOnScreen: Bool) -> Bool {
        if !disclaimerAlreadyOnScreen {
            if delegate != nil &&
                campaign?.settings?.disclaimer?.url != nil &&
                campaign?.settings?.disclaimer?.text != nil {
                return true
            }
        }
        return false
    }
}
