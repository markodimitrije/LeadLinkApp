//
//  RealmCampaign.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RealmSwift

class RealmCampaign: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var conference_id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var user_id: Int = 0
    @objc dynamic var organization_id: Int = 0
    @objc dynamic var created_at: String = ""// (Date)
    @objc dynamic var primary_color: String? // oprez - ne vidim iz response koji je ovo types
    @objc dynamic var color: String? // oprez - ne vidim iz response koji je ovo type
    @objc dynamic var logo: String? = "" // url
    @objc dynamic var imgData: Data?
    @objc dynamic var number_of_responses: Int = 0
    
    @objc dynamic var organization: RealmOrganization? = RealmOrganization()
    
    public var questions = List<RealmQuestion>()
    public var codes = List<RealmCode>()
    
    @objc dynamic var application: RealmApplication!
    
    @objc dynamic var settings: RealmSettings!
    
    @objc dynamic var dateReadAt: Date?

    public func update(with campaign: CampaignProtocol) {
        self.id = campaign.id
        self.name = campaign.name ?? Constants.Campaign.defaultName + "\(campaign.id)"
        self.desc = campaign.description ?? Constants.Campaign.defaultDesc + "\(campaign.id)"
        self.user_id = campaign.user_id ?? 0
        self.conference_id = campaign.conference_id
        self.organization_id = campaign.organization_id ?? 0
        self.created_at = campaign.created_at ?? Date.now.toString(format: Date.defaultFormatString)!
        self.primary_color = campaign.primary_color
        self.color = campaign.color
        self.logo = campaign.logo
        self.imgData = campaign.imgData
        self.number_of_responses = campaign.number_of_responses ?? 0
        
        if let organization = campaign.organization {
            let org = RealmOrganization()
            org.update(with: organization)
            self.organization = org
        }
        
        let realmApp = RealmApplication()
        realmApp.updateWith(application: campaign.application)
        self.application = realmApp
        
        if let settings = campaign.settings {
            let realmSettings = RealmSettings()
            realmSettings.update(with: settings, forCampaignId: campaign.id)
            self.settings = realmSettings
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
        
        let realm = RealmFactory.make()
        
        try? realm.write {
            
            questions.removeAll()
            questions.append(objectsIn: realmQuestions)
            
            codes.append(objectsIn: realmCodes)
        }
        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
        
}
