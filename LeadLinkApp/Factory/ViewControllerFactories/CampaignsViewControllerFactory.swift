//
//  CampaignsViewControllerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 21/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class CampaignsViewControllerFactory {
    var appDependancyContainer: AppDependencyContainer
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeCampaignsViewController() -> CampaignsVC {
        let campaignsVC = CampaignsVC.instantiate(using: appDependancyContainer.sb)
        campaignsVC.campaignsViewModel = appDependancyContainer.makeCampaignsViewModel()
        campaignsVC.factory = appDependancyContainer
        return campaignsVC
    }
}
