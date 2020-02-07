//
//  AnswersReport.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 18/04/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import RealmSwift

class AnswersReport: AnswersReportProtocol {
    
    private let payloadFactory = AnswersReportsToWebPayloadFactory()
    private var answers = [MyAnswerProtocol]()
    var campaignId = "0"
    var code = ""
    var success = false
    var date: Date = Date(timeIntervalSinceNow: 0)
    
    init(surveyInfo: SurveyInfo, date: Date? = nil, success: Bool) {
        self.answers = surveyInfo.answers
        self.code = surveyInfo.code
        self.campaignId = "\(surveyInfo.campaign.id)"
        self.success = success
        self.date = date ?? Date(timeIntervalSinceNow: 0)
    }
    
    init(realmAnswersReport: RealmWebReportedAnswers) {
        self.code = realmAnswersReport.code
        self.campaignId = realmAnswersReport.campaignId
        self.success = realmAnswersReport.success
        self.date = realmAnswersReport.date ?? Date(timeIntervalSinceNow: 0)
        self.loadAnswers()
    }

    private func loadAnswers() {
        let realm = RealmFactory.make()
        guard let campaignId = Int(campaignId) else {return}
        
        let realmAnswers = realm.objects(RealmAnswer.self).filter("campaignId == %i && code == %@", campaignId, code)
        answers = Array(realmAnswers).compactMap(MyAnswer.init)
    }
    
    // API:
    func getPayload() -> [[String: String]] {
        return answers.map {
            payloadFactory.make(answer: $0)
        }
    }
    
    func updated(withSuccess success: Bool) -> AnswersReportProtocol {
        let updated = self
        updated.success = success
        return updated
    }
    
}
