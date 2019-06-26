//
//  ScaningViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class ScaningViewModelFactory {
    
    var appDependancyContainer: AppDependencyContainer
    
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeViewModel(campaign: Campaign, codesDataStore: CodesDataStore? = nil) -> ScanningViewModel {
        
        let dataStoreFactory = CodesDataStoreFactory(appDependancyContainer: appDependancyContainer)
        let codesDataStore = dataStoreFactory.makeCodeDataStore()
        
        let scanningViewmodel = ScanningViewModel.init(campaign: campaign, codesDataStore: codesDataStore)
        
        return scanningViewmodel
    }
}
