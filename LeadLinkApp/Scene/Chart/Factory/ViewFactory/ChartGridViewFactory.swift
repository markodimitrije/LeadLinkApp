//
//  ChartGridViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 16/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

protocol ChartGridViewOutputing {
    var outputView: UIStackView! {get set}
    func makeOutput(webReports: [AnswersReportProtocol], campaign: CampaignProtocol) -> UIStackView
}

protocol ChartGridViewBuilding: ChartGridViewOutputing {}

class ChartGridViewFactory: ChartGridViewBuilding {
    
    var outputView: UIStackView!
    
    func makeOutput(webReports: [AnswersReportProtocol], campaign: CampaignProtocol) -> UIStackView {
        
        let compartmentsGridView = createGridView(webReports: webReports, campaign: campaign)
        let dateView = createDateView(webReports: webReports, campaign: campaign)

        let stackView = UIStackView(arrangedSubviews: [compartmentsGridView, dateView])
        stackView.axis = .vertical // format...
        
        return stackView
        
    }
    
    private func createGridView(webReports: [AnswersReportProtocol], campaign: CampaignProtocol) -> UIView {
        let values = CompartmentValues(campaign: campaign, webReports: webReports)
        let compartmentsBuilder = CompartmentBuilder(compartmentInfo: values)
        let compartmentsInGridViewFactory = CompartmentsInGridViewFactory(compartmentBuilder: compartmentsBuilder)
        return compartmentsInGridViewFactory.outputView
    }
    
    private func createDateView(webReports: [AnswersReportProtocol], campaign: CampaignProtocol) -> UIView {
        let chartLastSyncedAt = ChartRefreshDateCalculator(webReports: webReports, campaign: campaign).date
        let lastDateSyncViewFactory = LastDateSyncViewFactory(date: chartLastSyncedAt)
        return lastDateSyncViewFactory.outputView
    }
    
}
