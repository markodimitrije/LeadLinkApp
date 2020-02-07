//
//  Report.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 06/02/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol ReportProtocol {
    var code: String { get set }
    var date: Date? { get set }
    var sync: Bool { get set }
    var campaignId: Int { get set }
}

struct Report: ReportProtocol {
    
    var code: String
    var date: Date?
    var sync: Bool
    var campaignId: Int
    
    init(realmReport: RealmWebReportedAnswers) {
        self.code = realmReport.code
        self.date = realmReport.date
        self.sync = realmReport.success
        self.campaignId = Int(realmReport.campaignId)!
    }
}
