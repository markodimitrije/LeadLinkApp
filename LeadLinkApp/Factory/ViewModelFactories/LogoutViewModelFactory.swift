//
//  LogoutViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class LogoutViewModelFactory {
    
    var appDependancyContainer: AppDependencyContainer
    
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeViewModel() -> LogOutViewModel {
        
        let userSessionRepo = appDependancyContainer.sharedUserSessionRepository
        let mainViewModel = appDependancyContainer.sharedMainViewModel
        let mutableCampaignRepo = appDependancyContainer.campaignsMutableRepo
        
        let viewmodel = LogOutViewModel(userSessionRepository: userSessionRepo,
                                        notSignedInResponder: mainViewModel,
                                        mutableCampaignsRepo: mutableCampaignRepo)
        return viewmodel
    }
}
