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
        }
        
        let vc = QuestionsAnswersVC.instantiate(using: appDependancyContainer.sb)
        
        vc.reportAnswersToWebWorker = ReportAnswersToWebWorker(reportAnswersDataStore: AnswersReportDataStore())
        vc.obsDelegate = Observable.just(delegate)
        vc.surveyInfo = SurveyInfo.init(campaign: campaign, code: code, hasConsent: consent)
        
        return vc
    }
    
    func makeVC(codeValue: String, campaignId: Int) -> QuestionsAnswersVC {
        
        guard let campaign = campaignsDataStore.readCampaign(id: campaignId).value else {
            fatalError("no campaign value !?!")
        }
        
        let vc = QuestionsAnswersVC.instantiate(using: appDependancyContainer.sb)
        
        vc.reportAnswersToWebWorker = ReportAnswersToWebWorker(reportAnswersDataStore: AnswersReportDataStore())
        vc.obsDelegate = Observable.just(nil)
        vc.surveyInfo = SurveyInfo.init(campaign: campaign, code: codeValue)
        
        return vc
    }

}
