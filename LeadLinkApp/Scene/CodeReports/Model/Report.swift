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
    var date: Date { get set }
    var sync: Bool { get set }
    var campaignId: Int { get set }
}

struct Report: ReportProtocol {
    
    var code: String
    var date: Date
    var sync: Bool
    var campaignId: Int
    
    init(report: AnswersReportProtocol) {
        self.code = report.code
        self.date = report.date
        self.sync = report.success
        self.campaignId = Int(report.campaignId)!
    }
}

extension Report: Comparable {
    static func < (lhs: Report, rhs: Report) -> Bool {
        lhs.date < rhs.date
    }
    
    
}
