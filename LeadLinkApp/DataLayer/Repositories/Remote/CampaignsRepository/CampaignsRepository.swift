//
//  File.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit
import RxSwift

public protocol UserCampaignsRepository {
    
    //func readCampaigns(userSession: UserSession) -> Promise<[Campaign]>
    //func readQuestions(userSession: UserSession) -> Promise<[Question]> // imas u main proj..
    //func getCampaignsAndQuestions(userSession: UserSession) -> Promise<[(Campaign, [Question])]>
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

    //public func getCampaignsAndQuestions(userSession: UserSession) -> Promise<[(Campaign, [Question])]> {
    public func getCampaignsAndQuestions(userSession: UserSession) -> Promise<Bool> {
        
        //let s = when(fulfilled: [remoteAPI.getCampaignsAndQuestions(userSession: userSession)]
        
        
        let update = when(fulfilled: [remoteAPI.getCampaignsAndQuestions(userSession: userSession)])
            .then { results -> Promise<(Bool, CampaignResults)> in
                
                let promise = self.campaignsVersionChecker.needsUpdate(newCampaignData: (results.first!).jsonString)
                
                return promise.map({ update -> (Bool, CampaignResults) in
                    return (update, results.first!)
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
                
                var allCampaignsSaved = false; var allQuestionsSaved = false; // jsonUpdated ti je arg...

                let campaignsWithQuestions = results.campaignsWithQuestions

                allCampaignsSaved = self.dataStore.save(campaigns: campaignsWithQuestions.map {$0.0}).isFulfilled

                let quests = campaignsWithQuestions.map {$0.1}
                let savedQuestions = quests.map { questions -> Bool in
                    return self.questionsDataStore.save(questions: questions).isFulfilled
//                    when(fulfilled: self.dataStore.save(campaigns: campaignsWithQuestions.map {$0.0}),              self.questionsDataStore.save(questions: questions)).isFulfilled
                }

                allQuestionsSaved = !savedQuestions.contains(false)

                let shouldUpdate = allCampaignsSaved && allQuestionsSaved && jsonUpdated
                
                print("saved both (campaigns,questions) and json = \(shouldUpdate)")
                
                if shouldUpdate {
                    return (allCampaignsSaved && allQuestionsSaved && jsonUpdated)
                } else {
                    return false//Promise.init(error: CampaignError.unknown)
                }
                
            } else {
                print("CapmaignsRepository.getCampaignsAndQuestions. ne trebam update, isti json")
                return false
            }
            
        }
        
    }

}


