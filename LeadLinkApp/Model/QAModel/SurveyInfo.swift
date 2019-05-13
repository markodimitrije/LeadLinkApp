//
//  Models.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 11/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

enum InternalError: Error {
    case viewmodelConversion
}

struct SurveyInfo {
    
    var campaign: Campaign
    var code: String
    var dataStore: RealmAnswersDataStore
    
    var oVcWillAppear = BehaviorSubject<Bool>.init(value: false)
    
    //var dataStore: RealmAnswersDataStore?// = RealmAnswersDataStore.init()
    private let realmAnswersDataStore = RealmAnswersDataStore.init()
    
    var singleQuestions = [SingleQuestion]() {
        didSet {
            _ = singleQuestions.map { singleQuestion -> () in
                print("singleQuestions.answer = \(String(describing: singleQuestion.answer))")
            }
            
        }
    }
    
    mutating func loadAnswers(code: String) { // implement me
        
        singleQuestions = campaign.questions.map { question -> SingleQuestion in
            let realmAnswer = realmAnswersDataStore.answer(question: question, code: code)
            return SingleQuestion.init(question: question, realmAnswer: realmAnswer)
        }
    }
    
    var questions: [Question] {
        return campaign.questions
    }
    
    var answers = [MyAnswer]()
    
    init(campaign: Campaign, code: String, dataStore: RealmAnswersDataStore = RealmAnswersDataStore()) {
        self.campaign = campaign
        self.code = code
        self.dataStore = dataStore
        
        answers = campaign.questions.compactMap { question -> MyAnswer? in//Answer? in
            let answerIdentifier = AnswerIdentifer.init(campaignId: campaign.id, questionId: question.id, code: code)
            if let realmAnswer = dataStore.readAnswer(answerIdentifier: answerIdentifier).value,
                realmAnswer != nil {
                return MyAnswer.init(realmAnswer: realmAnswer)
            }
            return nil
        }
        
        oVcWillAppear
            .subscribe(onNext: { happened in
                if happened {
                    print("reload items")
                }
            }).disposed(by: bag)
    }
    
    func save(answers: [MyAnswer]) -> Observable<Bool> {
        
        return Observable.create({ (observer) -> Disposable in

            if let saveResult = self.dataStore.save(answers: answers, forCode: self.code).value, saveResult {
                observer.onNext(saveResult)
            } else {
                observer.onError(CampaignError.cantSave) // hard-coded  - cant save answers !
            }
            
            return Disposables.create()
        })
    }
    private let bag = DisposeBag()
}
