//
//  ChartViewControllerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class ChartViewControllerFactory {

    private var appDependancyContainer: AppDependencyContainer

    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }

    func makeVC(campaignId id: Int) -> ChartVC { print("ChartViewControllerFactory pravi ChartViewController")

        let chartVC = ChartVC.instantiate(using: appDependancyContainer.sb)

        let gridViewModel = self.createGridViewModel(campaignId: id)

        chartVC.gridViewModel = gridViewModel

        return chartVC

    }
    
    private func createGridViewModel(campaignId id: Int) -> GridViewModel {
        
        let campaign = appDependancyContainer.sharedCampaignsRepository.dataStore.observableCampaign(id: id)
        let webReports = RealmDataPersister.shared.getRealmWebReportedAnswers()
        
        return GridViewModel(campaign: campaign,
                             webReports: webReports)
    }
    
}

