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

public protocol UserCampaignsRepository {
    func getCampaignsAndQuestions(userSession: UserSession) -> Promise<Bool>
}

public class CampaignsRepository: UserCampaignsRepository {
    
    // MARK: - Properties
    let dataStore: CampaignsDataStore
    let userSessionRepository: UserSessionRepository
    let remoteAPI: CampaignsRemoteAPI
    let questionsDataStore: QuestionsDataStore
    let campaignsVersionChecker: CampaignsVersionChecker
    
    // MARK: - Methods
    public init(userSessionRepository: UserSessionRepository, dataStore: CampaignsDataStore, questionsDataStore: QuestionsDataStore, remoteAPI: CampaignsRemoteAPI, campaignsVersionChecker: CampaignsVersionChecker) {
        self.userSessionRepository = userSessionRepository
        self.dataStore = dataStore
        self.remoteAPI = remoteAPI
        self.questionsDataStore = questionsDataStore
        self.campaignsVersionChecker = campaignsVersionChecker
    }

    public func getCampaignsAndQuestions(userSession: UserSession) -> Promise<Bool> {
        
        let update =
            when(fulfilled: [remoteAPI.getCampaignsWithQuestions(userSession: userSession)])
            .then { results -> Promise<(Bool, CampaignResults)> in
                
                let promise = self.campaignsVersionChecker.needsUpdate(newJson: (results.first!).jsonString)
                
                return promise.map({ shouldUpdate -> (Bool, CampaignResults) in
                    return (shouldUpdate, results.first!)
                })
            }.map { (shouldUpdate, results) -> (Bool, CampaignResults) in
                
                if !shouldUpdate { // ako ne treba da update, samo izadji.....
                    return (shouldUpdate, results)
                }
                
                return (self.dataStore.saveCampaignsJsonString(requestName: WebRequestName.campaignsWithQuestions,
                                                               json: results.jsonString).isFulfilled, results)
                
        }
        
        return update.map { (jsonUpdated, results) -> Bool in
            
            if jsonUpdated {
                
                let campaignsWithQuestions = results.campaignsWithQuestions

                let allCampaignsSaved = self.dataStore.save(campaigns: campaignsWithQuestions.map {$0.0}).isFulfilled

                return allCampaignsSaved
                
            } else {
                print("CapmaignsRepository.getCampaignsAndQuestions. ne trebam update, isti json")
                return false
            }
            
        }
        
    }

    public func getCampaign(_ campaignId: Int) -> Campaign? {
        return self.dataStore.readCampaign(id: campaignId).value
    }
    
    func fetchCampaign(_ campaignId: Int) -> Observable<RealmCampaign> {
        let realm = try! Realm()
        guard let realmCampaign = realm.object(ofType: RealmCampaign.self, forPrimaryKey: campaignId) else {
            fatalError("someone asked for selected campaign, before it was saved ?!?")
        }
        
        //let campaign = Campaign.init(realmCampaign: realmCampaign)
        //return Observable.from(optional: campaign)
        
        return Observable.from(object: realmCampaign)
    }
}
