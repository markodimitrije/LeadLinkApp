//
//  BarOrChartDataImplementations.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 09/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct BarOrChartData: BarOrChartInfo {
    
    private var campaign: Campaign
    private var webReports: [RealmWebReportedAnswers]
    
    var otherDevicesSyncedCount = 0
    var thisDeviceSyncedCount = 0
    var thisDeviceNotSyncedCount = 0
    
    init(campaign: Campaign, webReports: [RealmWebReportedAnswers]) {
        self.campaign = campaign
        self.webReports = webReports
        self.populateMyVars()
    }
    
    private mutating func populateMyVars() {
        loadOtherDevicesSyncedCount()
        loadThisDeviceSyncedCount()
        loadThisDeviceNotSyncedCount()
    }
    
    private mutating func loadOtherDevicesSyncedCount() {
        otherDevicesSyncedCount = campaign.number_of_responses
    }
    
    private mutating func loadThisDeviceSyncedCount() {
        thisDeviceSyncedCount = webReports.filter {$0.success}.count
    }
    
    private mutating func loadThisDeviceNotSyncedCount() {
        thisDeviceNotSyncedCount = webReports.filter {!$0.success}.count
    }
}
