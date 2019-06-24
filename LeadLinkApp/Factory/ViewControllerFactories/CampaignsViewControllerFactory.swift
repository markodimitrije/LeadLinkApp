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
    
    func makeVC() -> CampaignsVC {
        
        let campaignsViewModelFactory = CampaignsViewModelFactory(appDependancyContainer: appDependancyContainer)
        let campaignsViewModel = campaignsViewModelFactory.makeViewModel()
        
        let campaignsVC = CampaignsVC.instantiate(using: appDependancyContainer.sb)
        campaignsVC.campaignsViewModel = campaignsViewModel
        campaignsVC.factory = appDependancyContainer
        return campaignsVC
    }
}
