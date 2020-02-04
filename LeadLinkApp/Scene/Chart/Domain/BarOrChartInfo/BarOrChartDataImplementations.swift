//
//  BarOrChartDataImplementations.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 09/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct BarOrChartData: BarOrChartInfo {
    
    private var campaign: CampaignProtocol
    private var webReports: [RealmWebReportedAnswers]
    
    var compartmentValues = [Int]()
    
    init(campaign: CampaignProtocol, webReports: [RealmWebReportedAnswers]) {
        self.campaign = campaign
        self.webReports = webReports
        self.loadCompartmentValues()
    }
    
    private mutating func loadCompartmentValues() {
        compartmentValues.append(campaign.number_of_responses ?? 0)
        let webReportsForSelectedCampaign = webReports.filter { $0.campaignId == "\(self.campaign.id)" }
        compartmentValues.append(webReportsForSelectedCampaign.filter {$0.success}.count)
        compartmentValues.append(webReportsForSelectedCampaign.filter {!$0.success}.count)
    }
}
