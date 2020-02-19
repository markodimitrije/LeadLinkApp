//
//  QuestionsAnswersViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 19/02/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

class QuestionsAnswersViewModelFactory {
    
    func make(surveyInfo: SurveyInfo, delegate: Delegate?) -> QuestionsAnswersViewModel {
        
        let getViewItemsWorkerFactory = QuestionPageGetViewItemsWorkerFactory()
        
        let reportAnswersToWebWorker = ReportAnswersToWebWorker(reportAnswersDataStore: AnswersReportDataStore())
        
        let obsDelegate = Observable<Delegate?>.just(delegate).share(replay: 1)
        
        
        let delegateEmailScrambler = DelegateEmailScrambler(campaign: surveyInfo.campaign)
        let prepopulateDelegateDecisioner = PrepopulateDelegateDataDecisioner(surveyInfo: surveyInfo, codeToCheck: surveyInfo.code)
        
        let validator = QA_ValidatorFactory().make(campaign: surveyInfo.campaign)
        
        let viewModel = QuestionsAnswersViewModel(surveyInfo: surveyInfo,
                                                  getViewItemsWorkerFactory: getViewItemsWorkerFactory,
                                                  reportAnswersToWebWorker: reportAnswersToWebWorker,
                                                  obsDelegate: obsDelegate,
                                                  prepopulateDelegateDataDecisioner: prepopulateDelegateDecisioner,
                                                  delegateEmailScrambler: delegateEmailScrambler,
                                                  validator: validator)
        return viewModel
    }
}
