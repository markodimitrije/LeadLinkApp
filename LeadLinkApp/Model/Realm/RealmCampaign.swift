//
//  RealmCampaign.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Realm
import RealmSwift
import RxRealm

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
    @objc dynamic var useScanditScanner: Bool = false
    @objc dynamic var number_of_responses: Int = 0
    
    @objc dynamic var organization: RealmOrganization? = RealmOrganization()
    
    public var questions = List<RealmQuestion>()
    public var codes = List<RealmCode>()
    
    @objc dynamic var application: RealmApplication!
    
    @objc dynamic var settings: RealmSettings!
    
    @objc dynamic var dateReadAt: Date?

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
        self.useScanditScanner = campaign.use_scandit_scanner ?? false
        self.number_of_responses = campaign.number_of_responses
        
        let org = RealmOrganization()
        org.update(with: campaign.organization)
        self.organization = org
        
        let realmApp = RealmApplication()
        realmApp.updateWith(application: campaign.application)
        self.application = realmApp
        
        if let settings = campaign.settings {
            let realmSettings = RealmSettings()
            realmSettings.update(with: settings, forCampaignId: campaign.id)
            self.settings = realmSettings
        } else {
            RealmDataPersister.shared.deleteAllObjects(ofTypes: [RealmSettings.self.self])
            self.settings = nil
        }
        
        self.dateReadAt = Date.now
        
        // prepare realmQuestions
        let realmQuestions = campaign.questions.map { question -> RealmQuestion in
            let rQuestion = RealmQuestion()
            rQuestion.updateWith(question: question)
            return rQuestion
        }
        
        // prepare realmCodes
        var realmCodes = [RealmCode]()
        if let codes = campaign.codes {
            realmCodes = codes.map { code -> RealmCode in
                let rCode = RealmCode()
                rCode.update(with: code)
                return rCode
            }
        }
        
        // update questions and codes
        try? Realm.init().write {
            
            questions.removeAll()
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
