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
        
        let update =
            when(fulfilled: [remoteAPI.getCampaignsWithQuestions(userSession: userSession)])
            .then { results -> Promise<(Bool, CampaignResults)> in
                    
                return Promise.init { (resolver) in
                    resolver.fulfill((true, results.first!))
                }
                
            }
        
        return update.map { (jsonUpdated, results) -> Bool in
                            
            let campaignsWithQuestions = results.campaignsWithQuestions

            let allCampaignsSaved = self.dataStore.save(campaigns: campaignsWithQuestions.map {$0.0}).isFulfilled

            return allCampaignsSaved

        }
        
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
