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
        let campaignsVC = CampaignsVC.instantiate(using: appDependancyContainer.sb)
        loadDependencies(campaignsVC: campaignsVC)
        return campaignsVC
    }
    
    private func loadDependencies(campaignsVC: CampaignsVC) {
        
        let campaignsViewModelFactory = CampaignsViewModelFactory(appDependancyContainer: appDependancyContainer)
        let campaignsViewModel = campaignsViewModelFactory.makeViewModel()
        campaignsVC.campaignsViewModel = campaignsViewModel
        
        campaignsVC.logOutViewModel = LogoutViewModelFactory(appDependancyContainer: appDependancyContainer).makeViewModel()
        campaignsVC.repository = factory.sharedUserSessionRepository
        campaignsVC.notSignedInResponder = factory.sharedMainViewModel
    }
}
