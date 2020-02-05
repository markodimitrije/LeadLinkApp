//
//  ChartViewControllerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

class ChartViewControllerFactory {

    private var appDependancyContainer: AppDependencyContainer
    private var selectedCampaign: SelectedCampaignObserving

    init(appDependancyContainer: AppDependencyContainer, selectedCampaign: SelectedCampaignObserving) {
        self.appDependancyContainer = appDependancyContainer
        self.selectedCampaign = selectedCampaign
    }

    func makeVC(campaignId id: Int) -> ChartVC {

        let chartVC = ChartVC.instantiate(using: appDependancyContainer.sb)

        let pieChartViewModel = self.createPieChartViewModel(campaignId: id)
        chartVC.pieChartViewModel = pieChartViewModel
        
        let gridViewModel = self.createGridViewModel(campaignId: id)
        chartVC.gridViewModel = gridViewModel
        
        return chartVC
    }
    
    private func createPieChartViewModel(campaignId id: Int) -> PieChartViewModel {
        
        let campaign = selectedCampaign.selectedCampaign()
        let webReports = AnswersReportDataStore.shared.getRealmWebReportedAnswers()
        
        return PieChartViewModel(campaign: campaign, webReports: webReports)
    }
    
    private func createGridViewModel(campaignId id: Int) -> GridViewModel {
        
        let campaign = selectedCampaign.selectedCampaign()
        let webReports = AnswersReportDataStore.shared.getRealmWebReportedAnswers()
        let viewFactory: ChartGridViewBuilding = ChartGridViewFactory()
        
        return GridViewModel(campaign: campaign,
                             webReports: webReports,
                             viewFactory: viewFactory)
    }
}
