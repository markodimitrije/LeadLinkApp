//
//  RealmCampaign.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Realm
import RealmSwift

//public struct Campaigns: Codable {
//    var data: [Campaign]
//}

class RealmCampaign: Object {
    //@objc dynamic var id = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var user_id: Int = 0
    @objc dynamic var conference_id: Int = 0
    @objc dynamic var organization_id: Int = 0
    @objc dynamic var created_at: String = ""// (Date)
    @objc dynamic var primary_color: String? // oprez - ne vidim iz response koji je ovo types
    @objc dynamic var color: String? // oprez - ne vidim iz response koji je ovo type
    @objc dynamic var logo: String? = "" // url
    @objc dynamic var imgData: Data?
    
    @objc dynamic var organization: RealmOrganization? = RealmOrganization()
    
    public var questions = List<RealmQuestion>()
    public var codes = List<RealmCode>()

    public func update(with campaign: Campaign) {
        self.id = campaign.id
        self.name = campaign.name
        self.desc = campaign.description
        self.user_id = campaign.user_id
        self.conference_id = campaign.conference_id
        self.organization_id = campaign.organization_id
        self.created_at = campaign.created_at
        self.primary_color = campaign.primary_color
        self.color = campaign.color
        self.logo = campaign.logo
        self.imgData = campaign.imgData
        
        let org = RealmOrganization(); org.update(with: campaign.organization)
        self.organization = org
        
        let realmQuestions = campaign.questions.map { question -> RealmQuestion in
            let rQuestion = RealmQuestion()
            rQuestion.updateWith(question: question)
            return rQuestion
        }
        
        var realmCodes = [RealmCode]()
        if let codes = campaign.codes {
            realmCodes = codes.map { code -> RealmCode in
                let rCode = RealmCode()
                rCode.update(with: code)
                return rCode
            }
        }
        
//        let realmCodes = (campaign.codes ?? []).compactMap { code -> RealmCode in
//            let rCode = RealmCode()
//            rCode.update(with: code)
//            return rCode
//        }
        
        print("appendujem questions.count = \(realmQuestions.count) i realmCodes.count = \(realmCodes.count)")
        try? Realm.init().write {
            questions.append(objectsIn: realmQuestions)
            codes.append(objectsIn: realmCodes)
        }
        
    }
    
    public func questions(forCampaignId id: Int) -> [RealmQuestion] {
        
        guard let realm = try? Realm.init() else {return [ ]}
        
        let questions: Results<RealmQuestion> = realm.objects(RealmQuestion.self).filter ("id == %@", id)
        
        return Array(questions)
        
    }
    
    public func questions(campaignId id: Int) -> [Question] {
        
        let rqs = questions(forCampaignId: id)

        return rqs.map {
            Question.init(realmQuestion: $0)
        }
        
    }
    
//    public func answers(campaignId id: Int, code: String) -> [Answer] {
//
//        fatalError("answers, implement me, send bar code.!! ")
//
//    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func updateImg(data: Data?, campaignId id: Int) {
        guard let realm = try? Realm.init() else {return}
        guard let record = realm.objects(RealmCampaign.self).first(where: {$0.id == id}) else {return}
        //print("RealmCampaign/updateImg. image data treba da su saved... ")
        try? realm.write {
            record.imgData = data
        }
    }
    
//    override static func ignoredProperties() -> [String] { // sta nije bitno za Scaner app?
//        return ["primary_color"]//, "floor", "imported_id"]
//    }
    
}

class RealmCode: Object {
    @objc dynamic var value: String = ""
    @objc dynamic var campaign_id: Int = 0
    var answers = List<RealmAnswer>()
    func update(with code: Code) {
        self.value = code.value
        self.campaign_id = code.campaign_id
        self.answers.append(objectsIn: code.answers.map(RealmAnswer.init))
    }
}

class Code: Codable {
    let value: String
    var campaign_id: Int
    var answers: [Answer]
    
    init(realmQuestion: RealmCode) {
        self.value = realmQuestion.value
        self.campaign_id = realmQuestion.campaign_id
        self.answers = realmQuestion.answers.toArray().map(Answer.init)
    }
}
