//
//  File.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

public protocol UserCampaignsRepository {
    
    //func readCampaigns(userSession: UserSession) -> Promise<[Campaign]>
    //func readQuestions(userSession: UserSession) -> Promise<[Question]> // imas u main proj..
    //func getCampaignsAndQuestions(userSession: UserSession) -> Promise<[(Campaign, [Question])]>
    func getCampaignsAndQuestions(userSession: UserSession) -> Promise<Bool>
}

public class CampaignsRepository: UserCampaignsRepository {
    
    // MARK: - Properties
    let dataStore: CampaignsDataStore
    let userSession: UserSession??
    let remoteAPI: CampaignsRemoteAPI
    let questionsDataStore: QuestionsDataStore
    
    // MARK: - Methods
    public init(userSession: UserSession??, dataStore: CampaignsDataStore, questionsDataStore: QuestionsDataStore, remoteAPI: CampaignsRemoteAPI) {
        self.userSession = userSession
        self.dataStore = dataStore
        self.remoteAPI = remoteAPI
        self.questionsDataStore = questionsDataStore
    }

    //public func getCampaignsAndQuestions(userSession: UserSession) -> Promise<[(Campaign, [Question])]> {
    public func getCampaignsAndQuestions(userSession: UserSession) -> Promise<Bool> {

        return remoteAPI.getCampaignsAndQuestions(userSession: userSession) // skini Campaigns... + (corr) Questions
            //.then(dataStore.save(campaigns:)) // skini questions...
            .then({ results -> Promise<Bool> in
                
                var allCampaignsSaved = false; var allQuestionsSaved = false;
                
                allCampaignsSaved = self.dataStore.save(campaigns: results.map {$0.0}).isFulfilled
                
                let quests = results.map {$0.1}
                let savedQuestions = quests.map { questions -> Bool in
                    return self.questionsDataStore.save(questions: questions).isFulfilled
                }
                
                allQuestionsSaved = !savedQuestions.contains(false)
                
                print("saved both campaigns and questions = \(allCampaignsSaved && allQuestionsSaved)")
                
                return Promise.value(allCampaignsSaved && allQuestionsSaved)
                
            })

    }

}
