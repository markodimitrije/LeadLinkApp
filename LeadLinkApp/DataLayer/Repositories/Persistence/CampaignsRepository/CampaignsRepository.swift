//
//  File.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit
import RxSwift
import RealmSwift

protocol CampaignsRepositoryProtocol {
    func getCampaignsAndQuestions(userSession: UserSession) -> Promise<Bool> // TODO: MOVE!! ...
    func fetchCampaign(_ campaignId: Int) -> Observable<CampaignProtocol>
}

extension CampaignsRepository: CampaignsRepositoryProtocol {
    
    func getCampaignsAndQuestions(userSession: UserSession) -> Promise<Bool> {
        
        let camRes = remoteAPI.getCampaignsWithQuestions(userSession: userSession)
        let arr = camRes.map {$0.campaignsWithQuestions}
        let campaigns = arr.mapValues { $0.0 }
        return campaigns.then(self.dataStore.save).map {_ in return true}
    }
    
    func fetchCampaign(_ campaignId: Int) -> Observable<CampaignProtocol> {
        let realm = try! Realm()
        guard let realmCampaign = realm.object(ofType: RealmCampaign.self, forPrimaryKey: campaignId) else {
            fatalError("someone asked for selected campaign, before it was saved ?!?")
        }
        
        return Observable.from(object: realmCampaign).map(Campaign.init)
    }
}

public class CampaignsRepository {
    
    // MARK: - Properties
    let dataStore: CampaignsDataStore
    let userSessionRepository: UserSessionRepository
    let remoteAPI: CampaignsRemoteAPI
    let questionsDataStore: QuestionsDataStoreProtocol
    
    // MARK: - Methods
    init(userSessionRepository: UserSessionRepository, dataStore: CampaignsDataStore, questionsDataStore: QuestionsDataStoreProtocol, remoteAPI: CampaignsRemoteAPI) {
        self.userSessionRepository = userSessionRepository
        self.dataStore = dataStore
        self.remoteAPI = remoteAPI
        self.questionsDataStore = questionsDataStore
    }

}
