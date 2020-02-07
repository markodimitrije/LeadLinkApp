
//
//  AnswersDataStore.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 21/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit
import RealmSwift

protocol AnswersDataStoreProtocol {
    func save(answers: [MyAnswerProtocol], forCode code: String) -> Promise<Bool>
    func readAnswer(answerIdentifier: AnswerIdentifer?) -> Promise<MyAnswerProtocol?>
    func answer(campaign_id: Int, questionId: Int, code: String) -> MyAnswerProtocol?
    func answers(campaign_id: Int, code: String) -> [MyAnswerProtocol]
}

public class AnswersDataStore: AnswersDataStoreProtocol {
    
    // MARK: - GET
    func readAnswer(answerIdentifier: AnswerIdentifer?) -> Promise<MyAnswerProtocol?> {
        
        return Promise() { seal in
            
            let realm = RealmFactory.make()
            
            guard let answerIdentifier = answerIdentifier,
                let result = realm.object(ofType: RealmAnswer.self, forPrimaryKey: answerIdentifier.compositeId) else {
                    seal.fulfill(nil)
                    return
            }
            
            seal.fulfill(MyAnswer.init(realmAnswer: result))
            
        }
        
    }
    
    func answer(campaign_id: Int, questionId: Int, code: String) -> MyAnswerProtocol? {
        
        let realm = RealmFactory.make()
        
        let compositeId = "\(campaign_id)" + "\(questionId)" + code
        
        guard let result = realm.object(ofType: RealmAnswer.self, forPrimaryKey: compositeId) else {
            return nil
        }
        return MyAnswer(realmAnswer: result)
    }
    
    func answers(campaign_id: Int, code: String) -> [MyAnswerProtocol] { // TODO: ne vracaj realm obj !
        let realm = RealmFactory.make()
        return
            realm.objects(RealmAnswer.self)
                .filter("code == %@ && campaignId == %i", code, campaign_id)
                .toArray()
                .compactMap(MyAnswer.init)
    }
    
    // MARK: - SAVE
    func save(answers: [MyAnswerProtocol], forCode code: String) -> Promise<Bool> {
        
        return Promise() { seal in
            
            let realm = RealmFactory.make()
            
            let objects = answers.compactMap { answer -> RealmAnswer? in
                let rAnswer = RealmAnswer()
                rAnswer.updateWith(answer: answer)
                return rAnswer
            }
            
            do {
                try realm.write { // ovako
                    realm.add(objects, update: .modified)
                }
                print("SAVED ANSWERS!")
                seal.fulfill(true)
            } catch {
                seal.fulfill(false)
            }
            
        }
    }
    
}

