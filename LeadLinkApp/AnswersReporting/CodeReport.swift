//
//  CodeReport.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 18/04/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class CodeReport: Object { // Realm Entity
    
    private var answers = [MyAnswer]()
    private var date: Date = Date(timeIntervalSinceNow: 0)
    
    var payload: [[String: String]] {
        return answers.map { $0.toWebReportJson() }
    }
    
    init(answers: [MyAnswer], date: Date? = nil) {
        self.answers = answers
        self.date = date ?? Date(timeIntervalSinceNow: 0)
        super.init()
    }
    
//    init(realmCodeReport: RealmCodeReport) {
//        self.code = realmCodeReport.code
//        self.sessionId = realmCodeReport.sessionId
//        self.date = realmCodeReport.date ?? Date(timeIntervalSinceNow: 0)
//        super.init()
//    }

    func getPayload() -> [[String: String]] {  print("CodeReport.getPayload = \(answers.map { $0.toWebReportJson() })")
        return answers.map { $0.toWebReportJson() }
    }
    
//    static func getPayload(_ report: CodeReport) -> [String: String] {
//
//        return [
//            "time_of_scan": report.date.toString(format: Date.defaultFormatString) ?? ""
//        ]
//    }
//
//    static func getPayload(_ reports: [CodeReport]) -> [String: Any] {
//
//        let listOfReports = reports.map {getPayload($0)}
//
//        return ["data": listOfReports]
//    }
    
    // kompajler me tera da implementiram, mogu li ikako bez toga ? ...
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
}
