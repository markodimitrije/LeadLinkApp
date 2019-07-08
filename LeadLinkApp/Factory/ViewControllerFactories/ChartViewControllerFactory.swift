//
//  ChartViewControllerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class ChartViewControllerFactory {
    
    private var appDependancyContainer: AppDependencyContainer
    
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeVC(campaignId id: Int) -> ChartVC {
        
        print("ChartViewControllerFactory pravi ChartViewController")
        
        let chartVC = ChartVC.instantiate(using: appDependancyContainer.sb)

        let campaign = appDependancyContainer.sharedCampaignsRepository.dataStore.readCampaign(id: id)
        
        let viewmodel = ChartViewModel(campaign: campaign.value!,
                                       webReports: RealmDataPersister.shared.getRealmWebReportedAnswers())

        chartVC.chartViewModel = viewmodel

        return chartVC
        
    }
}
