//
//  AnswersReport.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 18/04/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import RealmSwift

class AnswersReport {
    
    private let answersWebReportFactory = AnswersWebReportFactory()
    private var answers = [MyAnswerProtocol]()
    var campaignId = "0"
    var code = ""
    var success = false
    var date: Date = Date(timeIntervalSinceNow: 0)
    
    var payload: [[String: String]] { print("AnswersReport.payload.code = \(code)")
        guard let answers = answers as? [MyAnswer] else {
            fatalError("unknown protocol")
        }
        return answers.map { $0.toWebReportJson() }
    }
    
    init(surveyInfo: SurveyInfo, answers: [MyAnswerProtocol], date: Date? = nil, success: Bool) {
        self.answers = answers
        self.code = surveyInfo.code
        self.campaignId = "\(surveyInfo.campaign.id)"
        self.success = success
        self.date = date ?? Date(timeIntervalSinceNow: 0)
//        super.init()
        self.loadAnswers()
    }
    
    init(realmAnswersReport: RealmWebReportedAnswers) {
        self.code = realmAnswersReport.code
        self.campaignId = realmAnswersReport.campaignId
        self.success = realmAnswersReport.success
        self.date = realmAnswersReport.date ?? Date(timeIntervalSinceNow: 0)
//        super.init()
        self.loadAnswers()
    }

    private func loadAnswers() {
        guard let realm = try? Realm.init(),
             let campaignId = Int(campaignId) else {return}
        
        let realmAnswers = realm.objects(RealmAnswer.self).filter("campaignId == %i && code == %@", campaignId, code)
        answers = Array(realmAnswers).compactMap(MyAnswer.init)
    }
    
    func getPayload() -> [[String: String]] {  //print("AnswersReport.getPayload = \(answers.map { $0.toWebReportJson() })")
        //return answers.map { $0.toWebReportJson() }
        return answers.map {
            answersWebReportFactory.make(answer: $0)
        }
    }
    
    func updated(withSuccess success: Bool) -> AnswersReport {
        let updated = self
        updated.success = success
        return updated
    }
    
}

class AnswersWebReportFactory {
    func make(answer: MyAnswerProtocol) -> [String: String] {
        var res = [String: String]()
        res["question_id"] = "\(answer.questionId)"
        res["content"] = concatanateIfMultipleOptionsIn(content: answer.content)
        return res
    }
    private func concatanateIfMultipleOptionsIn(content: [String]) -> String {
        if content.count == 1 {
            return content.first!
        } else {
            return content.joined(separator: ", ")
        }
    }
}
