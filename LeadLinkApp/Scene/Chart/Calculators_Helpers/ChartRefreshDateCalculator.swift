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
    private var campaign: Campaign
    
    var date: Date {
        if webReports.isEmpty {return campaign.dateReadAt!}
        let lastWebReportDate = (webReports.compactMap {$0.date}).max()!
        let lastCampaignDate = campaign.dateReadAt
        return max(lastWebReportDate, lastCampaignDate!)
    }
    
    init(webReports: [RealmWebReportedAnswers], campaign: Campaign) {
        self.webReports = webReports
        self.campaign = campaign
    }
}
