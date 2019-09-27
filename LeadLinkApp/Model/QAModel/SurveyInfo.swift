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
    var hasConsent = false
    
    var oVcWillAppear = BehaviorSubject<Bool>.init(value: false)
    
    private let realmAnswersDataStore = RealmAnswersDataStore.init()
    
    var surveyQuestions = [SurveyQuestion]()
    var questions: [Question] { return campaign.questions }
    var answers = [MyAnswer]()
    
    init(campaign: Campaign,
         code: String,
         hasConsent: Bool = false,
         dataStore: RealmAnswersDataStore = RealmAnswersDataStore()) {
        
        self.campaign = campaign
        self.code = code
        self.hasConsent = hasConsent
        self.dataStore = dataStore
    
        answers = campaign.questions.compactMap { question -> MyAnswer? in//Answer? in
            let answerIdentifier = AnswerIdentifer.init(campaignId: campaign.id, questionId: question.id, code: code)
            if let realmAnswer = dataStore.readAnswer(answerIdentifier: answerIdentifier).value,
                realmAnswer != nil {
                return MyAnswer.init(realmAnswer: realmAnswer)
            }
            return nil
        }
        
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

    func realmCampaignHasAnswersFor(codeValue code: String) -> Bool { // rename
        guard let realm = try? Realm() else { return false } // treba exception!
        let codeExists = realm.objects(RealmAnswer.self).filter("code == %@ && campaignId == %i", code, self.campaign.id).first != nil
        return codeExists
    }
    
    private let bag = DisposeBag()
}

extension SurveyInfo {
    
    func updated(withDelegate delegate: Delegate) -> SurveyInfo {
        let actualAnswers = self.answers
        var newAnswers = actualAnswers
        
        _ = delegate.myStringProperties.compactMap { property -> Void in
            
            if property != nil,
                let personalKey = property!.questionPersonalInfoKey,
                let _ = question(forKey: personalKey)?.id,
                shouldLoadAnswerWithDelegateData(optionKey: personalKey) { // we want answer not to exist (only pre-load)
                
                let preloadAnswer = makeAnswer(forKey: personalKey,
                                               delegate: delegate)
//                print("dodaj answer tipa = \(personalKey.rawValue)")
                newAnswers.append(preloadAnswer)
                
            }
        }
        
        var updatedSurvey = self
        updatedSurvey.answers = newAnswers + [barcodeAnswer()]
        
        return updatedSurvey
    }
    
    private func shouldLoadAnswerWithDelegateData(optionKey: QuestionPersonalInfoKey) -> Bool {
        if existingAnswer(forKey: optionKey) == nil {return true}
        let answer = existingAnswer(forKey: optionKey)!
//        print("shouldLoadAnswerWithDelegateData/za optionKey= \(optionKey) vracam answer.isEmpty = \(answer.isEmpty)")
        return answer.isEmpty
    }
    
    private func question(forKey optionKey: QuestionPersonalInfoKey) -> Question? { // ili PersonalInfoKey ?
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
        guard let question = self.question(forKey: optionKey) else {fatalError()}// hard-coded
        return MyAnswer.init(question: question,
                             code: self.code,
                             content: [delegate.value(optionKey: optionKey)],
                             optionIds: nil)
    }
    
    private func barcodeAnswer() -> MyAnswer {
        guard let question = self.questions.first(where: { question -> Bool in
            question.settings.options?.first == "barcode"
        }) else {
            fatalError("nemam barcode kao question !!?!?")
        }
        return MyAnswer.init(question: question,
                             code: self.code,
                             content: [self.code],
                             optionIds: nil)
    }
    
    private func barcodeQuestion() -> Question? { // ili PersonalInfoKey ?
        guard let myQuestion = self.questions.first(where: { question -> Bool in
            question.settings.options?.first == "barcode" || question.settings.options?.first == "Barcode"
        }) else {
            return nil
        }
        
        return myQuestion
    }
    
}
