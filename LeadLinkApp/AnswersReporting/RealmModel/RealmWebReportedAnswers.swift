//
//  RealmWebReportedAnswers.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 21/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RealmSwift

class RealmWebReportedAnswers: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var campaignId: String = "0"
    @objc dynamic var code: String = ""
    @objc dynamic var success: Bool = false
    @objc dynamic var date: Date?
    
    static func create(report: AnswersReportProtocol) -> RealmWebReportedAnswers {
        let object = RealmWebReportedAnswers()
        object.campaignId = report.campaignId
        object.code = report.code
        object.success = report.success
        object.id = object.campaignId + object.code
        object.date = report.date
        return object
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
