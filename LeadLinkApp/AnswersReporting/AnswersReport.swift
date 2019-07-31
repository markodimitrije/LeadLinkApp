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

class AnswersReport: Object { // Realm Entity
    
    private var answers = [MyAnswer]()
    var campaignId = "0"
    var code = ""
    var success = false
    var date: Date = Date(timeIntervalSinceNow: 0)
    
    var payload: [[String: String]] {
        print("code = \(code)")
        return answers.map { $0.toWebReportJson() }
    }
    
    init(surveyInfo: SurveyInfo, answers: [MyAnswer], date: Date? = nil, success: Bool) {
        self.answers = answers
        self.code = surveyInfo.code
        self.campaignId = "\(surveyInfo.campaign.id)"
        self.success = success
        self.date = date ?? Date(timeIntervalSinceNow: 0)
        super.init()
        self.loadAnswers()
    }
    
    init(realmAnswersReport: RealmWebReportedAnswers) {
        self.code = realmAnswersReport.code
        self.campaignId = realmAnswersReport.campaignId
        self.success = realmAnswersReport.success
        self.date = realmAnswersReport.date ?? Date(timeIntervalSinceNow: 0)
        super.init()
        self.loadAnswers()
    }

    private func loadAnswers() {
        guard let realm = try? Realm.init(),
             let campaignId = Int(campaignId) else {return}
        
        let realmAnswers = realm.objects(RealmAnswer.self).filter("campaignId == %i && code == %@", campaignId, code)
        answers = Array(realmAnswers).compactMap(MyAnswer.init)
    }
    
    func getPayload() -> [[String: String]] {  print("AnswersReport.getPayload = \(answers.map { $0.toWebReportJson() })")
        return answers.map { $0.toWebReportJson() }
    }
    
    func updated(withSuccess success: Bool) -> AnswersReport {
        let updated = self
        updated.success = success
        return updated
    }
    
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
