//
//  QuestionsAnswersViewControllerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 21/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

class QuestionsAnswersViewControllerFactory {
    
    private var appDependancyContainer: AppDependencyContainer
    private var campaignsDataStore: CampaignsDataStore {
        return appDependancyContainer.sharedCampaignsRepository.dataStore
    }
    
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeVC(scanningViewModel viewModel: ScanningViewModel?,
                hasConsent consent: Bool = false,
                delegate: Delegate?) -> QuestionsAnswersVC {
        
        guard let code = try? viewModel!.codeInput.value() else {fatalError()}
        
        guard let campaignId = selectedCampaignId,
            let campaign = campaignsDataStore.readCampaign(id: campaignId).value else {
            fatalError("no campaign selected or no campaign found !?!")
                // TODO: ima unsynced state, kampanje su updated ali je selektovana neka koja je u medjuvremenu obrisana na konfiguratoru -> alert + force logout
        }
        
        let vc = QuestionsAnswersVC.instantiate(using: appDependancyContainer.sb)
        
        let surveyInfo = SurveyInfo.init(campaign: campaign, code: code, hasConsent: consent)
        let viewmodel = QuestionsAnswersViewModelFactory().make(surveyInfo: surveyInfo,
                                                                delegate: delegate)
        vc.viewModel = viewmodel
        
        return vc
    }
    
    func makeVC(codeValue: String, campaignId: Int) -> QuestionsAnswersVC {
        
        guard let campaign = campaignsDataStore.readCampaign(id: campaignId).value else {
            fatalError("no campaign value !?!")
        }
        
        let vc = QuestionsAnswersVC.instantiate(using: appDependancyContainer.sb)
        
        let surveyInfo = SurveyInfo.init(campaign: campaign, code: codeValue)
        let viewmodel = QuestionsAnswersViewModelFactory().make(surveyInfo: surveyInfo, delegate: nil)
        vc.viewModel = viewmodel
        
        return vc
    }

}

class QuestionsAnswersViewModelFactory {
    
    func make(surveyInfo: SurveyInfo, delegate: Delegate?) -> QuestionsAnswersViewModel {
        
        let getViewItemsWorkerFactory = QuestionPageGetViewItemsWorkerFactory()
        
        let reportAnswersToWebWorker = ReportAnswersToWebWorker(reportAnswersDataStore: AnswersReportDataStore())
        
        let obsDelegate = Observable<Delegate?>.just(delegate).share(replay: 1)
        
        
        let delegateEmailScrambler = DelegateEmailScrambler(campaign: surveyInfo.campaign)
        let prepopulateDelegateDecisioner = PrepopulateDelegateDataDecisioner(surveyInfo: surveyInfo, codeToCheck: surveyInfo.code)
        
        let viewModel = QuestionsAnswersViewModel(surveyInfo: surveyInfo,
                                                  getViewItemsWorkerFactory: getViewItemsWorkerFactory,
                                                  reportAnswersToWebWorker: reportAnswersToWebWorker,
                                                  obsDelegate: obsDelegate,
                                                  prepopulateDelegateDataDecisioner: prepopulateDelegateDecisioner,
                                                  delegateEmailScrambler: delegateEmailScrambler)
        return viewModel
    }
}

protocol QuestionPageGetViewItemsWorkerFactoryProtocol {
    func make(surveyInfo: SurveyInfo) -> QuestionPageGetViewItemsWorker
}

class QuestionPageGetViewItemsWorkerFactory: QuestionPageGetViewItemsWorkerFactoryProtocol {
    func make(surveyInfo: SurveyInfo) -> QuestionPageGetViewItemsWorker {
        let surveyQuestions = SurveyQuestionsLoader(surveyInfo: surveyInfo).getSurveyQuestions()
        let helper = ViewInfoProvider(campaign: surveyInfo.campaign,
                                      questions: surveyQuestions,
                                      code: surveyInfo.code)
        let viewInfos = helper.getViewInfos()

        let getViewItemsWorker = QuestionPageGetViewItemsWorker(viewInfos: viewInfos,
                                                                campaign: surveyInfo.campaign)
        return getViewItemsWorker
    }
}
