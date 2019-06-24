//
//  CampaignsViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class CampaignsViewModelFactory {
    
    var appDependancyContainer: AppDependencyContainer
    
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeViewModel() -> CampaignsViewModel {
        
        let campaignsRepo = appDependancyContainer.sharedCampaignsRepository
        
        return CampaignsViewModel.init(campaignsRepository: campaignsRepo)
    }
    
}
