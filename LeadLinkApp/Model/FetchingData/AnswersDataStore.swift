
//
//  AnswersDataStore.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 21/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit
import Realm
import RealmSwift

protocol DataStoreAnswering {
    func readAnswer(answerIdentifier: AnswerIdentifer?) -> Promise<RealmAnswer?>
}

public class RealmAnswersDataStore: DataStoreAnswering {
    
    // MARK: - Properties
    var realm = try! Realm.init()
    
    func readAnswer(answerIdentifier: AnswerIdentifer?) -> Promise<RealmAnswer?> {
        
        return Promise() { seal in
            
            guard let _ = try? Realm.init() else {
                seal.reject(CampaignError.unknown)
                return
            }
            
            guard let answerIdentifier = answerIdentifier,
                let result = realm.object(ofType: RealmAnswer.self, forPrimaryKey: answerIdentifier.compositeId) else {
                    seal.fulfill(nil)
                    return
            }
            
            seal.fulfill(result)
            
        }
        
    }
    
    func answer(question: Question, code: String) -> RealmAnswer? {
        
        guard let _ = try? Realm.init() else {
            return nil
        }
        
        let compositeId = "\(question.campaign_id)" + "\(question.id)" + code
        
        guard let result = realm.object(ofType: RealmAnswer.self, forPrimaryKey: compositeId) else {
//            print("nemam odgovor u bazi....")
            return nil
        }
//        print("imam odgovor u bazi....")
        return result
    }
    
    func answer(campaign_id: Int, questionId: Int, code: String) -> RealmAnswer? {
        
        guard let _ = try? Realm.init() else { return nil }
        
        let compositeId = "\(campaign_id)" + "\(questionId)" + code
        
        guard let result = realm.object(ofType: RealmAnswer.self, forPrimaryKey: compositeId) else {
//            print("nemam odgovor u bazi....")
            return nil
        }
//        print("imam odgovor u bazi....")
        return result
    }
    
    func save(answers: [MyAnswer], forCode code: String) -> Promise<Bool> {
        
        return Promise() { seal in
            
            let objects = answers.compactMap { answer -> RealmAnswer? in
                let rAnswer = RealmAnswer()
                rAnswer.updateWith(answer: answer)
                return rAnswer
            }
            
            do {
                try realm.write { // ovako
                    realm.add(objects, update: true)
                }
                print("SAVED ANSWERS!")
                seal.fulfill(true)
            } catch {
                seal.fulfill(false)
            }
            
        }
    }
    
    public func delete(answers: [Answer]) -> Promise<[RealmAnswer]> {
        
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
