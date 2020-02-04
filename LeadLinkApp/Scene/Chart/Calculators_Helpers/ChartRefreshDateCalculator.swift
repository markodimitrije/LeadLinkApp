//
//  ChartRefreshDateCalculator.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class ChartRefreshDateCalculator {
    
    private var webReports: [RealmWebReportedAnswers]
    private var campaign: CampaignProtocol
    
    var date: Date {
        if webReports.isEmpty {return campaign.dateReadAt!}
        let lastWebReportDate = (webReports.compactMap {$0.date}).max()!
        let lastCampaignDate = campaign.dateReadAt
        return max(lastWebReportDate, lastCampaignDate!)
    }
    
    init(webReports: [RealmWebReportedAnswers], campaign: CampaignProtocol) {
        self.webReports = webReports
        self.campaign = campaign
    }
}
