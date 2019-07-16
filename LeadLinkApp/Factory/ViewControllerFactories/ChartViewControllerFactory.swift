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
    private var selectedCampaign: SelectedCampaignObserving

    init(appDependancyContainer: AppDependencyContainer, selectedCampaign: SelectedCampaignObserving) {
        self.appDependancyContainer = appDependancyContainer
        self.selectedCampaign = selectedCampaign
    }

    func makeVC(campaignId id: Int) -> ChartVC { print("ChartViewControllerFactory pravi ChartViewController")

        let chartVC = ChartVC.instantiate(using: appDependancyContainer.sb)

        let gridViewModel = self.createGridViewModel(campaignId: id)
        chartVC.gridViewModel = gridViewModel
        
        let pieChartViewModel = self.createPieChartViewModel(campaignId: id)
        chartVC.pieChartViewModel = pieChartViewModel
        
        return chartVC

    }
    
    private func createGridViewModel(campaignId id: Int) -> GridViewModel {
        
        let campaign = selectedCampaign.selectedCampaign() //appDependancyContainer.sharedCampaignsRepository.dataStore.observableCampaign(id: id)
        let webReports = RealmDataPersister.shared.getRealmWebReportedAnswers()
        let viewFactory: ChartGridViewBuilding = ChartGridViewFactory()
        
        return GridViewModel(campaign: campaign,
                             webReports: webReports,
                             viewFactory: viewFactory)
    }
    
    private func createPieChartViewModel(campaignId id: Int) -> PieChartViewModel {
        
        let campaign = selectedCampaign.selectedCampaign() //appDependancyContainer.sharedCampaignsRepository.dataStore.observableCampaign(id: id)
        let webReports = RealmDataPersister.shared.getRealmWebReportedAnswers()
        let viewFactory: PieChartViewBuilding = PieChartViewFactory()
        
        return PieChartViewModel(campaign: campaign,
                                 webReports: webReports,
                                 viewFactory: viewFactory)
    }
    
}

