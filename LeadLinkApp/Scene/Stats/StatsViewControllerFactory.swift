//
//  StatsViewControllerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class StatsViewControllerFactory {
    
    var appDependancyContainer: AppDependencyContainer
    
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeVC(campaignId id: Int) -> StatsVC {

        let chartVcFactory =
            ChartViewControllerFactory.init(
                appDependancyContainer: appDependancyContainer,
                answersReportDataStore: AnswersReportDataStore(),
                selectedCampaign: RealmSelectedCampaign.init(campaignsDataStore: appDependancyContainer.campaignsDataStore))
        
        let reportsVcFactory =
            ReportsViewControllerFactory(appDependancyContainer: appDependancyContainer)
        
        let statsVC = StatsVC.instantiate(using: appDependancyContainer.sb)
        
        statsVC.reportsVC = reportsVcFactory.makeVC(campaignId: id)
        statsVC.chartVC = chartVcFactory.makeVC(campaignId: id)
        
        return statsVC
    }
}
