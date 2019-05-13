//
//  FetchingData.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 21/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

//protocol DataFetching {
//    func getQuestions(campaignId id: Int) -> Promise<[Question]>
//    func getAnswer(questionId id: Int, code: String) -> Promise<Answer?>
//}
//
//struct DataFetcher {
//
//    var campaignsDataStore: RealmCampaignsDataStore
//    var answersDataStore: RealmAnswersDataStore
//    init(campaignsDataStore: RealmCampaignsDataStore, answersDataStore: RealmAnswersDataStore) {
//        self.campaignsDataStore = campaignsDataStore
//        self.answersDataStore = answersDataStore
//    }
//
//    func getQuestions(campaignId id: Int) -> Promise<[Question]> {
//        return campaignsDataStore.readCampaign(id: id).map {$0.questions}
//    }
//    func getAnswer(questionId id: Int, code: String) -> Promise<Answer?> {
//
//        //return answersDataStore.readAnswer(questionId: id, code: code).map(Answer.init)
//        return answersDataStore.readAnswer(questionId: id, code: code).map(Answer.init)
//    }
//}
