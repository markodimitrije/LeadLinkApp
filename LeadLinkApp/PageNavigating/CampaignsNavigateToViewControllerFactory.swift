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
    let scaningViewModelFactory = ScaningViewModelFactory(appDependancyContainer: factory)
    
    func getNavigationDestination(dict: [String: Any]) -> UIViewController? {
        
        guard let campaignId = dict["campaignId"] as? Int,
            let campaign = campaignsRepo.getCampaign(campaignId) else {
                return nil
        }
        
        let scanningViewModel = self.scaningViewModelFactory.makeViewModel(campaign: campaign)
        let scaningVcFactory = ScaningViewControllerFactory(appDependancyContainer: factory)
        let scanningVC = scaningVcFactory.makeVC(viewModel: scanningViewModel)
        
        return scanningVC
    }
}
