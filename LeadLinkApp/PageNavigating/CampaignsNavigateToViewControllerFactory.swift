//
//  CampaignsNavigateToViewControllerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

struct CampaignsNavigateToViewControllerFactory: PageNavigatingProtocol {
    
    let campaignsRepo = factory.sharedCampaignsRepository
    let scanningViewModelFactory = ScanningViewModelFactory(appDependancyContainer: factory)
    
    func getNavigationDestination(dict: [String: Any]) -> UIViewController? {
        
        guard let campaignId = dict["campaignId"] as? Int,
            let campaign = campaignsRepo.getCampaign(campaignId) else {
                return nil
        }
        
        //let scanningViewModel = self.scanningViewModelFactory.makeViewModel(campaign: campaign)
        let scanningViewModel = self.scanningViewModelFactory.makeViewModel(campaignRepository: campaignsRepo)
        let scanningVcFactory = ScanningViewControllerFactory(appDependancyContainer: factory)
        let scanningVC = scanningVcFactory.makeVC(viewModel: scanningViewModel)
        
        return scanningVC
    }
}
