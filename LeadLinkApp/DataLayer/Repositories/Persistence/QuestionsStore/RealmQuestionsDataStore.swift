//
//  File.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 08/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit
import Realm
import RealmSwift

public class RealmQuestionsDataStore: QuestionsDataStoreProtocol {
    
    // MARK: - Properties
    var realm = try! Realm.init()
    
    func readAllQuestions() -> Promise<[QuestionProtocol]> {
        
        return Promise() { seal in
            
            guard let _ = try? Realm.init() else {
                seal.reject(CampaignError.unknown)
                return
            }
            
            let results = realm.objects(RealmQuestion.self).sorted(by: {$0.id < $1.id})
            
            let questions = results.map {Question.init(realmQuestion: $0)}
            
            seal.fulfill(questions)
            
        }
        
    }
    
    func save(questions: [QuestionProtocol]) -> Promise<[QuestionProtocol]> {
        
//        print("Realm location = \(Realm.Configuration.defaultConfiguration.fileURL!)")
        return Promise() { seal in
            
            let objects = questions.compactMap { question -> RealmQuestion in
                
                let rc = RealmQuestion()
                rc.updateWith(question: question)
                return rc
            }
            
            do {
                try realm.write { // ovako
                    realm.add(objects, update: .modified)
                }
                seal.fulfill(questions)
            } catch {
                seal.reject(CampaignError.cantSave)
            }
            
        }
    }
    
    func delete(questions: [QuestionProtocol]) -> Promise<[QuestionProtocol]> {
        
        let ids = questions.map {$0.qId}
        
        return Promise() { seal in
            
            let objects = realm.objects(RealmQuestion.self).filter { question -> Bool in
                return ids.contains(question.id)
            }
            
            do {
                try realm.write { // ovako
                    realm.delete(objects)
                }
                seal.fulfill(questions)
            } catch {
                seal.reject(CampaignError.cantDelete)
            }
            
        }
    }
    
}

