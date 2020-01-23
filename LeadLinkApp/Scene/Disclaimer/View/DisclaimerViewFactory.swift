//
//  DisclaimerViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 08/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class DisclaimerViewFactory {
    
    func create(campaign: Campaign?) -> DisclaimerView? {
        guard let topVC = UIApplication.topViewController() else {
            return nil
        }
        guard let disclaimer = campaign?.settings?.disclaimer else {
            return nil
        }
        let disclaimerInfo = DisclaimerViewInfo(disclaimer: disclaimer)
        return DisclaimerView.init(frame: topVC.view.frame, disclaimerInfo: disclaimerInfo)
    }
}
