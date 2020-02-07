
//
//  RealmAnswersDataStore.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 21/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit
import RealmSwift

protocol AnswersDataStore {
    func readAnswer(answerIdentifier: AnswerIdentifer?) -> Promise<MyAnswerProtocol?>
}

public class RealmAnswersDataStore: AnswersDataStore {
    
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
    
    func answer(question: Question, code: String) -> RealmAnswer? {
        
        let realm = RealmFactory.make()
        
        let compositeId = "\(question.campaign_id)" + "\(question.id)" + code
        
        guard let result = realm.object(ofType: RealmAnswer.self, forPrimaryKey: compositeId) else {
//            print("nemam odgovor u bazi....")
            return nil
        }
//        print("imam odgovor u bazi....")
        return result
    }
    
    func answer(campaign_id: Int, questionId: Int, code: String) -> RealmAnswer? {
        
        let realm = RealmFactory.make()
        
        let compositeId = "\(campaign_id)" + "\(questionId)" + code
        
        guard let result = realm.object(ofType: RealmAnswer.self, forPrimaryKey: compositeId) else {
//            print("nemam odgovor u bazi....")
            return nil
        }
//        print("imam odgovor u bazi....")
        return result
    }
    
    func answers(campaign_id: Int, code: String) -> [RealmAnswer] { // TODO: ne vracaj realm obj !
        let realm = RealmFactory.make()
        return
            realm.objects(RealmAnswer.self)
                .filter("code == %@ && campaignId == %i", code, campaign_id)
                .toArray()
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
    // MARK: - DELETE
    public func delete(answers: [MyAnswer]) -> Promise<[RealmAnswer]> {
        
        let realm = RealmFactory.make()
        let ids = answers.map {$0.id}
        
        return Promise() { seal in
            
            let objects = realm.objects(RealmAnswer.self).filter { answer -> Bool in
                return ids.contains(answer.id)
            }
            
            do {
                try realm.write { // ovako
                    realm.delete(objects)
                }
                seal.fulfill(Array(objects))
            } catch {
                seal.reject(CampaignError.cantDelete)
            }
            
        }
    }
}

