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

        return remoteAPI.getCampaignsAndQuestions(userSession: userSession) // skini Campaigns... + (corr) Questions
            
            .then({ results -> Promise<Bool> in
                
                var allCampaignsSaved = false; var allQuestionsSaved = false; var jsonUpdated = false
                
                let needsUpdate = self.campaignsVersionChecker.needsUpdate(newCampaignData: results.jsonString)
                
                needsUpdate.done({ needs in
                    if needs {
                        
                        let saved = self.dataStore.saveCampaignsJsonString(requestName: WebRequestName.campaignsWithQuestions,
                                                                       json: results.jsonString)
                        
                        jsonUpdated = saved.isFulfilled
                        
                    } else {
                        print("CapmaignsRepository.getCampaignsAndQuestions. ne trebam update, isti json")
                    }
                }).catch { err in
                    print("CapmaignsRepository.getCampaignsAndQuestions.err = \(err), nije saved ceo json od kampanja...")
                }
                
                let campaignsWithQuestions = results.campaignsWithQuestions
                
                allCampaignsSaved = self.dataStore.save(campaigns: campaignsWithQuestions.map {$0.0}).isFulfilled
                
                let quests = campaignsWithQuestions.map {$0.1}
                let savedQuestions = quests.map { questions -> Bool in
                    return self.questionsDataStore.save(questions: questions).isFulfilled
                }
                
                allQuestionsSaved = !savedQuestions.contains(false)
                
                print("saved both (campaigns,questions) and json = \(allCampaignsSaved && allQuestionsSaved && jsonUpdated)")
                
                return Promise.value(allCampaignsSaved && allQuestionsSaved && jsonUpdated)
                //return Promise.value(true) // hard-coded
                
            })

    }

}
