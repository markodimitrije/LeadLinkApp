//
//  ScaningViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class ScanningViewModelFactory {
    
    var appDependancyContainer: AppDependencyContainer
    
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    //func makeViewModel(campaignRepository: CampaignsRepositoryProtocol,
    func makeViewModel(campaignRepository: ICampaignsImmutableRepository,
                       codesDataStore: CodesDataStore? = nil) -> ScanningViewModel {
        
        let dataStoreFactory = CodesDataStoreFactory(appDependancyContainer: appDependancyContainer)
        let codesDataStore = dataStoreFactory.makeCodeDataStore()
        
        let obsCampaign = campaignRepository.fetchCampaign(selectedCampaignId!)
        
        let scanningViewmodel = ScanningViewModel.init(obsCampaign: obsCampaign, codesDataStore: codesDataStore)
        
        return scanningViewmodel
    }
}
