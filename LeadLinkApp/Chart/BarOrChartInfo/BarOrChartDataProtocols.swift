//
//  BarOrChartDataProtocols.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 09/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol BarOrChartInfo {
    //init(campaign: Campaign, webReports: [RealmWebReportedAnswers])
    var otherDevicesSyncedCount: Int {get set}
    var thisDeviceSyncedCount: Int {get set}
    var thisDeviceNotSyncedCount: Int {get set}
}
