//
//  Models.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 11/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import Realm
import RealmSwift

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

extension SurveyInfo {
    
    func updated(withDelegate delegate: Delegate) -> SurveyInfo {
        let actualAnswers = self.answers
        var newAnswers = actualAnswers
        
        if delegate.email != nil,
            let _ = question(forKey: .email)?.id,
            let answer = existingAnswer(forKey: .email),
            answer.isEmpty { // we want answer not to exist (only pre-load)
 
            let preloadAnswer = makeAnswer(forKey: .email,
                                           delegate: delegate)
            
            newAnswers.append(preloadAnswer)
            
        } else {
            print("sto ne uhvati...")
        }
        
        
        return self // hard-coded
    }
    
    private func question(forKey optionKey: QuestionPersonalInfoKey ) -> Question? { // ili PersonalInfoKey ?
        guard let myQuestion = self.questions.first(where: { question -> Bool in
            question.settings.options?.first == optionKey.rawValue
        }) else {
            return nil
        }
        
        return myQuestion
    }
    
    private func existingAnswer(forKey optionKey: QuestionPersonalInfoKey ) -> MyAnswer? { // ili PersonalInfoKey ?
        
        guard let myQuestion = question(forKey: optionKey) else {
            return nil
        }

        let dataStore = RealmAnswersDataStore.init()
        
        let rAnswer = dataStore.answer(campaign_id: self.campaign.id,
                                       questionId: myQuestion.id,
                                       code: self.code)
        
        return MyAnswer.init(realmAnswer: rAnswer)
        
    }
    
    private func makeAnswer(forKey optionKey: QuestionPersonalInfoKey, delegate: Delegate) -> MyAnswer {
        return MyAnswer.init(campaignId: self.campaign.id,
                             questionId: self.question(forKey: optionKey)?.id ?? 0, // hard-coded
                             code: self.code,
                             content: [delegate.email ?? ""],
                             optionIds: nil)
    }
    
}
