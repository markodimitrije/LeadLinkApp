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
        
        let campaignsWorker = CampaignsWorkerFactory.make()
        let downloadImageAPI = appDependancyContainer.downloadImageAPI
        
        return CampaignsViewModel.init(campaignsWorker: campaignsWorker,
                                       downloadImageAPI: downloadImageAPI)
    }
    
}
