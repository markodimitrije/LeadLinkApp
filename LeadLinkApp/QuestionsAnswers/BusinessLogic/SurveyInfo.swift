//
//  Models.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 11/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift

enum InternalError: Error {
    case viewmodelConversion
}

struct SurveyInfo {
    
    var campaign: CampaignProtocol
    var code: String
    var dataStore: AnswersDataStoreProtocol
    var hasConsent = false
    
    var oVcWillAppear = BehaviorSubject<Bool>.init(value: false)
    
    private let realmAnswersDataStore = AnswersDataStore.init()
    
    var surveyQuestions = [SurveyQuestionProtocol]()
    var questions: [QuestionProtocol] { return campaign.questions }
    var answers = [MyAnswerProtocol]()
    
    init(campaign: CampaignProtocol,
         code: String,
         hasConsent: Bool = false,
         dataStore: AnswersDataStoreProtocol = AnswersDataStore()) {
        
        self.campaign = campaign
        self.code = code
        self.hasConsent = hasConsent
        self.dataStore = dataStore
    
        answers = campaign.questions.compactMap { question -> MyAnswerProtocol? in
            let answerIdentifier = AnswerIdentifer.init(campaignId: campaign.id, questionId: question.qId, code: code)
            if let answer = dataStore.readAnswer(answerIdentifier: answerIdentifier).value,
                answer != nil {
                return answer
            }
            return nil
        }
        
    }
    
    func save(answers: [MyAnswerProtocol]) -> Observable<Bool> {
        
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
        let codeExists = dataStore.answers(campaign_id: self.campaign.id, code: code).first != nil
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
                let _ = question(forKey: personalKey)?.qId,
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
        let answer = existingAnswer(forKey: optionKey)
        if answer == nil {return true}
        return answer!.isEmpty
    }
    
    private func question(forKey optionKey: QuestionPersonalInfoKey) -> QuestionProtocol? { // ili PersonalInfoKey ?
        guard let myQuestion = self.questions.first(where: { question -> Bool in
            question.qSettings.options?.first == optionKey.rawValue
        }) else {
            return nil
        }
        
        return myQuestion
    }
    
    private func existingAnswer(forKey optionKey: QuestionPersonalInfoKey ) -> MyAnswerProtocol? { // ili PersonalInfoKey ?
        
        guard let myQuestion = question(forKey: optionKey) else {
            return nil
        }

        let dataStore = AnswersDataStore.init()
        
        let answer = dataStore.answer(campaign_id: self.campaign.id,
                                       questionId: myQuestion.qId,
                                       code: self.code)
        
        return answer
        
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
            question.qSettings.options?.first == "barcode"
        }) else {
            fatalError("nemam barcode kao question !!?!?")
        }
        return MyAnswer.init(question: question, code: self.code, content: [self.code], optionIds: nil)
    }
    
}
