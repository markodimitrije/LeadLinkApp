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
    func updateImg(data: Data?, campaignId id: Int)
    func fetchCampaign(_ campaignId: Int) -> Observable<CampaignProtocol>
}

extension CampaignsRepository: CampaignsRepositoryProtocol {
    
    func getCampaignsAndQuestions(userSession: UserSession) -> Promise<Bool> {
        
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
                
                return (self.dataStore.saveCampaignsJsonString(requestName: WebRequestName.campaignsWithQuestions, json: results.jsonString).isFulfilled, results)
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
    
    func updateImg(data: Data?, campaignId id: Int) {
        guard let realm = try? Realm.init() else {return}
        guard let record = realm.objects(RealmCampaign.self).first(where: {$0.id == id}) else {return}
        //print("RealmCampaign/updateImg. image data treba da su saved... ")
        try? realm.write {
            record.imgData = data
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
    let campaignsVersionChecker: CampaignsVersionChecker
    
    // MARK: - Methods
    init(userSessionRepository: UserSessionRepository, dataStore: CampaignsDataStore, questionsDataStore: QuestionsDataStoreProtocol, remoteAPI: CampaignsRemoteAPI, campaignsVersionChecker: CampaignsVersionChecker) {
        self.userSessionRepository = userSessionRepository
        self.dataStore = dataStore
        self.remoteAPI = remoteAPI
        self.questionsDataStore = questionsDataStore
        self.campaignsVersionChecker = campaignsVersionChecker
    }

}
