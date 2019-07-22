//
//  DisclaimerViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 08/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class DisclaimerViewFactory {
    
    func create() -> DisclaimerView? {
        guard let topVC = UIApplication.topViewController() else {
            return nil
        }
        
        let disclaimerInfo = DisclaimerInfo()
        return DisclaimerView.init(frame: topVC.view.frame, disclaimer:  disclaimerInfo)
    }
}
